# Nushell Environment Config File
#
# version = 0.78.0

def create_left_prompt [] {
    mut home = ""
    try {
        if $nu.os-info.name == "windows" {
            $home = $env.USERPROFILE
        } else {
            $home = $env.HOME
        }
    }

    let dir = ([
        ($env.PWD | str substring 0..($home | str length) | str replace -s $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

    let path_segment = if (is-admin) {
        $"(ansi red_bold)($dir)"
    } else {
        $"(ansi green_bold)($dir)"
    }

    $path_segment
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | date format '%m/%d/%Y %r')
    ] | str join)

    $time_segment
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = {|| create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = {|| "> " }
let-env PROMPT_INDICATOR_VI_INSERT = {|| ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
let-env PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
let-env PATH = ($env.PATH | split row (char esep) | append '~/.cargo/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '~/.rbenv/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '~/.nimble/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '/opt/homebrew/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '/usr/local/opt/curl/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '/usr/local/opt/sqlite/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '/usr/local/opt/libressl/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '/usr/local/opt/MacGPG2/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '/usr/local/opt/gnu-getopt/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '~/.composer/vendor/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '/usr/local/go/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '/usr/local/opt/go/libexec/bin')
let-env PATH = ($env.PATH | split row (char esep) | append '~/gocode')
let-env PATH = ($env.PATH | split row (char esep) | append '~/gocode/bin')
let-env PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/sbin')
let-env PATH = ($env.PATH | split row (char esep) | prepend '/opt/local/bin')
let-env PATH = ($env.PATH | split row (char esep) | prepend '/opt/local/sbin')
let-env PATH = ($env.PATH | split row (char esep) | prepend '/opt/X11/bin')
let-env PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/bin')
let-env PATH = ($env.PATH | split row (char esep) | prepend '~/.local/bin')
let-env PATH = ($env.PATH | split row (char esep) | prepend '~/bin')

# env vars

let-env LANG = 'ja_JP.UTF-8'
let-env EDITOR = 'code'
let-env GPG_TTY = (tty)
# let-env PRODB15331TOKEN = (open --raw "~/.ssh/tokens/PRODB15331TOKEN")
open ~/.ssh/tokens/api-tokens.nuon | load-env

# custom commands
def allup [] {
  print $"(ansi bg_blue) ====== MAINTAIN BREW ====== (ansi reset)"
  cd
  print $"(ansi bg_purple) 🍻 Updating brew... (ansi reset)"
  brew update
  print $"(ansi bg_purple) 🍻 Upgrading brew... (ansi reset)"
  brew upgrade
  print $"(ansi bg_purple) 🍻 Cleaning up brew to keep only last version... (ansi reset)"
  brew cleanup -s
  print $"(ansi bg_purple) 🍻 Calling the DOCTOR and find what is missing... (ansi reset)"
  brew doctor
  brew missing
  print $"(ansi bg_purple) 🍻 Updating brew casks and cleaning up... (ansi reset)"
  brew cu --all --yes --cleanup
}

def renu [] {
  # sourced files need to be available before the script can be checked or run
  # not working
  # source '($nu.env-path)'
  # source '($nu.config-path)'
  # print 'Reloaded nu env and config'
}

def qrenco [url:string] { curl $"qrenco.de/https://($url)" }

def stup [emoji:string, msg:string] {
  let hdr = $"'Authorization: Bearer ($env.OMGLOL)'"
  let omgacct = rick
  let apiurl = $"'https://api.omg.lol/address/($omgacct)/statuses/'"
  let qry = $"'{"emoji": "($emoji)", "content": "($msg)"}'"
  curl --location --request POST --header $hdr $apiurl --data $qry
}

def ttt [] {
  let omgacct = rick
  let apiurl = $"'https://api.omg.lol/address/($omgacct)/statuses/'"
  print $apiurl
}
