# .zshenv is sourced on all invocations of the shell, unless the -f option is set.
# It should contain commands to set the command search path, plus other important
# environment variables. .zshenv should not contain commands that produce output
# or assume the shell is attached to a tty.

# Ensure path arrays are unique
typeset -gU cdpath fpath mailpath path

# Set ZDOTDIR if not already set
: ${ZDOTDIR:=$HOME}

# Ensure basic paths are set. Guarded on existence so a directory that is absent
# on this machine (/usr/local/sbin, on an Apple Silicon box with no Intel
# Homebrew) does not linger as a dead PATH entry.
_base_path=()
for _d in /opt/homebrew/bin /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin; do
  [[ -d $_d ]] && _base_path+=($_d)
done
path=($_base_path $path)
unset _base_path _d

# Export PATH
export PATH