#!/usr/bin/env python3
"""guard-recursive-delete.py: Claude Code PreToolUse hook for the Bash tool.

A boundary, not a tripwire. The old permission rule `Bash(rm -rf:*)` matched
one spelling and blocked it everywhere, including the session scratchpad.
This hook blocks every recursive delete it can recognise unless every target
path is strictly inside an allowed root, and it fails closed when it cannot
tell where a delete would land.

Recognised forms:
  rm with -r / -R / --recursive (any option order, any spelling of the flags),
    also via sudo, command, env, nice, nohup, time, exec, or xargs
  find ... -delete, find ... -exec/-execdir/-ok/-okdir rm ...
  shutil.rmtree("...") in inline Python or heredocs
  rimraf <paths>
  rsync --delete* ... <dest>

Allowed roots (edit ALLOWED_ROOTS / ALLOWED_SEGMENTS):
  the session scratchpad under /private/tmp/claude-501 (and /tmp/claude-501)
  any path inside a <repo>/.claude/worktrees/ directory

Fail-closed cases: a target that contains a shell variable or command
substitution, a relative target with no cwd, paths fed on stdin (xargs),
rmtree() with a non-literal argument, and a command line the shell parser
cannot split. The deny message says what to do instead.

Known false positive: a heredoc or quoted document that contains text like
`rm -rf something` is parsed as if it were a command. Write such files with
the Write tool instead of a shell heredoc.

Wiring (user settings.json):
  "hooks": {"PreToolUse": [{"matcher": "Bash", "hooks": [{"type": "command",
    "command": "python3 -I \\"$HOME/.dotfiles/claude/.claude/hooks/guard-recursive-delete.py\\"",
    "timeout": 10, "onFailure": "block"}]}]}

Pipe test:
  echo '{"tool_name":"Bash","cwd":"/Users/x","tool_input":{"command":"rm -rf build"}}' \\
    | python3 -I guard-recursive-delete.py

InfoSec: preventive control against destructive deletes by an agent; read-only
over its input; no network; stdlib only.
"""

from __future__ import annotations

import json
import os
import re
import shlex
import sys

ALLOWED_ROOTS = ("/private/tmp/claude-501", "/tmp/claude-501")
ALLOWED_SEGMENTS = ("/.claude/worktrees/",)

WRAPPERS = {"sudo", "command", "env", "nice", "nohup", "time", "exec", "builtin", "doas"}
BOUNDARIES = {";", "&&", "||", "|", "&", "\n", "(", ")", ";;", "|&"}
DELETE_PROGRAMS = {"rm", "find", "rimraf", "rsync"}

TRIGGER = re.compile(
    r"(?:^|[\s;&|(`'\"])(?:/\S*/)?(?:rm|find|rimraf|rsync)(?:\s|$)|rmtree\s*\(",
    re.MULTILINE,
)


def deny(reason: str) -> None:
    print(
        json.dumps(
            {
                "hookSpecificOutput": {
                    "hookEventName": "PreToolUse",
                    "permissionDecision": "deny",
                    "permissionDecisionReason": (
                        "guard-recursive-delete: "
                        + reason
                        + " Recursive deletes are allowed only inside the session scratchpad "
                        "(/private/tmp/claude-501/...) or a .claude/worktrees/ checkout, "
                        "with literal paths. For anything else, ask the user to run it."
                    ),
                }
            }
        )
    )
    sys.exit(0)


def resolve(path: str, cwd: str | None) -> str | None:
    """Absolute, normalised path, or None when it cannot be known statically."""
    if any(ch in path for ch in "$`"):
        return None
    if path.startswith("~"):
        path = os.path.expanduser(path)
    if not os.path.isabs(path):
        if not cwd:
            return None
        path = os.path.join(cwd, path)
    return os.path.normpath(path)


def is_allowed(path: str) -> bool:
    for root in ALLOWED_ROOTS:
        if path.startswith(root + "/") and len(path) > len(root) + 1:
            return True
    for seg in ALLOWED_SEGMENTS:
        idx = path.find(seg)
        if idx != -1 and path[idx + len(seg):].strip("/"):
            return True
    return False


def check_paths(paths: list[str], cwd: str | None, what: str) -> None:
    if not paths:
        deny(f"{what} with no literal target path.")
    for p in paths:
        resolved = resolve(p, cwd)
        if resolved is None:
            deny(f"{what} on a target that cannot be resolved statically ({p!r}).")
        if not is_allowed(resolved):
            deny(f"{what} outside the allowed roots: {resolved}.")


def split_segments(command: str) -> list[list[str]]:
    # Newlines are command separators too, so they are punctuation here, not
    # whitespace. A heredoc body therefore parses as commands; see the header.
    lexer = shlex.shlex(command, posix=True, punctuation_chars=";&|()<>\n")
    lexer.whitespace = " \t\r"
    lexer.whitespace_split = True
    lexer.commenters = ""
    tokens = list(lexer)
    segments: list[list[str]] = [[]]
    i = 0
    while i < len(tokens):
        tok = tokens[i]
        nxt = tokens[i + 1] if i + 1 < len(tokens) else ""
        if tok == "":
            # an empty quoted argument ('' or ""); harmless, keep it as an arg
            segments[-1].append(tok)
            i += 1
            continue
        if tok in BOUNDARIES or all(c in ";&|()\n" for c in tok):
            if segments[-1]:
                segments.append([])
            i += 1
            continue
        if tok.isdigit() and nxt and nxt[0] in "<>":
            # file-descriptor prefix of a redirection, e.g. the 2 in 2>/dev/null
            i += 1
            continue
        if tok[0] in "<>" or tok in {"&>", "&>>"}:
            # redirection operator: drop it and its target (a file or an fd)
            i += 2
            continue
        segments[-1].append(tok)
        i += 1
    return [s for s in segments if s]


def basename(tok: str) -> str:
    return os.path.basename(tok)


def locate_program(segment: list[str]) -> tuple[str | None, int, bool]:
    """Return (program, index, via_xargs) for the first delete program in the segment."""
    via_xargs = False
    i = 0
    while i < len(segment):
        tok = segment[i]
        if "=" in tok and not tok.startswith("-") and re.match(r"^[A-Za-z_][A-Za-z0-9_]*=", tok):
            i += 1
            continue
        name = basename(tok)
        if name in WRAPPERS:
            i += 1
            continue
        if name == "xargs":
            via_xargs = True
            i += 1
            continue
        if name in DELETE_PROGRAMS:
            return name, i, via_xargs
        if via_xargs and tok.startswith("-"):
            # xargs options such as -0, -n1, -I {}; keep looking for the program
            i += 1
            continue
        return None, i, via_xargs
    return None, i, via_xargs


def check_rm(args: list[str], cwd: str | None, via_xargs: bool) -> None:
    recursive = False
    paths: list[str] = []
    opts_done = False
    for a in args:
        if not opts_done and a == "--":
            opts_done = True
            continue
        if not opts_done and a.startswith("--"):
            if a == "--recursive":
                recursive = True
            continue
        if not opts_done and a.startswith("-") and len(a) > 1:
            if "r" in a or "R" in a:
                recursive = True
            continue
        paths.append(a)
    if not recursive:
        return
    if via_xargs:
        deny("recursive rm fed by xargs; the targets are not visible to the guard.")
    check_paths(paths, cwd, "recursive rm")


def check_find(args: list[str], cwd: str | None) -> None:
    starts: list[str] = []
    for a in args:
        if a.startswith("-") or a in {"(", "!", ")"}:
            break
        starts.append(a)
    destructive = "-delete" in args
    for i, a in enumerate(args):
        if a in {"-exec", "-execdir", "-ok", "-okdir"} and i + 1 < len(args):
            if basename(args[i + 1]) in {"rm", "rimraf", "unlink", "shred"}:
                destructive = True
    if not destructive:
        return
    check_paths(starts or ["."], cwd, "find with -delete/-exec rm")


def check_rimraf(args: list[str], cwd: str | None) -> None:
    paths = [a for a in args if not a.startswith("-")]
    check_paths(paths, cwd, "rimraf")


def check_rsync(args: list[str], cwd: str | None) -> None:
    if not any(a.startswith("--delete") for a in args):
        return
    positional = [a for a in args if not a.startswith("-")]
    if len(positional) < 2:
        deny("rsync --delete without a visible destination.")
    dest = positional[-1]
    if ":" in dest and not os.path.isabs(dest):
        deny(f"rsync --delete to a remote destination ({dest}).")
    check_paths([dest], cwd, "rsync --delete")


def check_rmtree(command: str, cwd: str | None) -> None:
    calls = re.findall(r"rmtree\s*\(\s*([^)]*)\)", command)
    if not calls:
        return
    for call in calls:
        # Quotes may arrive shell-escaped (\" inside a double-quoted -c string).
        literal = re.match(r"""\s*(r|f)?\\?(['"])(.*?)\\?\2""", call)
        if not literal or (literal.group(1) == "f" and "{" in literal.group(3)):
            deny("shutil.rmtree() with a non-literal path.")
        check_paths([literal.group(3)], cwd, "shutil.rmtree")


def fallback_regex(command: str, cwd: str | None) -> None:
    """Used when the shell parser cannot split the command. Fail closed."""
    if re.search(r"(?:^|[\s;&|(`])(?:/\S*/)?rm\s+(?:\S+\s+)*?(?:-\w*[rR]\w*|--recursive)\b", command, re.M):
        deny("could not parse a command line that contains a recursive rm.")
    if re.search(r"(?:^|[\s;&|(`])(?:/\S*/)?find\s.*?(?:-delete|-exec\w*\s+(?:/\S*/)?rm\b)", command, re.M | re.S):
        deny("could not parse a command line that contains find -delete / -exec rm.")
    if re.search(r"(?:^|[\s;&|(`])rimraf\s", command, re.M):
        deny("could not parse a command line that contains rimraf.")
    if re.search(r"(?:^|[\s;&|(`])rsync\s.*--delete", command, re.M | re.S):
        deny("could not parse a command line that contains rsync --delete.")


def main() -> int:
    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0
    if data.get("tool_name") != "Bash":
        return 0
    command = str((data.get("tool_input") or {}).get("command") or "")
    cwd = data.get("cwd") or None
    if not command or not TRIGGER.search(command):
        return 0

    check_rmtree(command, cwd)

    try:
        segments = split_segments(command)
    except ValueError:
        fallback_regex(command, cwd)
        return 0

    for seg in segments:
        program, idx, via_xargs = locate_program(seg)
        if program is None:
            continue
        args = seg[idx + 1:]
        if program == "rm":
            check_rm(args, cwd, via_xargs)
        elif program == "find":
            check_find(args, cwd)
        elif program == "rimraf":
            check_rimraf(args, cwd)
        elif program == "rsync":
            check_rsync(args, cwd)
    return 0


if __name__ == "__main__":
    sys.exit(main())
