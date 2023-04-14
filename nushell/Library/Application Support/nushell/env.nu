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
let-env PATH = (
    $env.PATH | split row (char esep)
    | prepend '~/.cargo/bin'
    | append '~/.rbenv/bin'
    | append '~/.nimble/bin'
    | prepend '/opt/homebrew/bin'
    | append '/usr/local/opt/curl/bin'
    | append '/usr/local/opt/sqlite/bin'
    | append '/usr/local/opt/libressl/bin'
    | append '/usr/local/opt/MacGPG2/bin'
    | append '/usr/local/opt/gnu-getopt/bin'
    | append '~/.composer/vendor/bin'
    | append '/usr/local/go/bin'
    | append '/usr/local/opt/go/libexec/bin'
    | append '~/gocode'
    | append '~/gocode/bin'
    | prepend '/usr/local/sbin'
    | prepend '/opt/local/bin'
    | prepend '/opt/local/sbin'
    | prepend '/opt/X11/bin'
    | prepend '/usr/local/bin'
    | prepend '~/.local/bin'
    | prepend '~/bin'
    | uniq
)


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

def statusup [emoji:string, msg:string] {
  let omgacct = rick
  let apiurl = $"https://api.omg.lol/address/($omgacct)/statuses/"
  let qry = $"{"emoji": "($emoji)", "content": "($msg)"}"
  http post -H ["Authorization" $"Bearer ($env.OMGLOL)"] -t application/json $apiurl $qry
}

# get the environment details
def "env details" [] {
  let e = ($env | reject config | transpose key value)
  $e | each { |r|
    let is_envc = ($r.key == ENV_CONVERSIONS)
    let is_closure = ($r.value | describe | str contains 'closure')
    let is_list = ($r.value | describe | str contains 'list')
    if $is_envc {
      echo [[key value]; 
        [($r.key) ($r.value | transpose key value | each { |ec| 
          let to_string = ($ec.value | get to_string | view source $in | nu-highlight)
          let from_string = ($ec.value | get from_string | view source $in | nu-highlight)
          echo ({'ENV_CONVERSIONS': {($ec.key): { 'to_string': ($to_string) 'from_string': ($from_string)}}})
        })]
      ]
    } else if $is_closure {
      let closure_value = (view source ($env | get $r.key) | nu-highlight)
      echo [[key value]; [($r.key) ($closure_value)]]
    } else if $is_list {
      let list_value = ($env | get $r.key | split row (char esep))
      echo [[key value]; [($r.key) ($list_value)]]
    } else {
      echo [[key value]; [($r.key) ($r.value)]]
    }
  }
}

def env [] { env details | flatten | table -e }

def pgenxx [] {
  #let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+"
  #let len = 16n
  #let pass = (str repeat $len $chars | str shuffle)
  #print $pass
}

# Generate password of 3 dictionary file words, numbers and symbols
def nupass [
  word_length: int = 4    # Max length of 3 words in password
  --debug    # Include debug info
  ] { 

  let dictfile = $"/usr/local/bin/genpass-dict-jp"
  # get the dictionary file with:
  # http get https://raw.githubusercontent.com/RickCogley/jpassgen/master/genpass-dict-jp.txt | save genpass-dict-jp
  # TODO test:
  # let dictfile = (http get https://raw.githubusercontent.com/RickCogley/jpassgen/master/genpass-dict-jp.txt)
  
  # Find number of lines with strings less than or equal to the supplied length
  let numlines = (open ($dictfile) | lines | wrap word | upsert len {|it| $it.word | split chars | length} | where len <= ($word_length) | length)
  
  # Get three random line numbers from 1 to numlines
  let randline1 = (random integer 1..($numlines))
  let randline2 = (random integer 1..($numlines))
  let randline3 = (random integer 1..($numlines))
  
  # Get the associated words from the file
  let randword1 = (open ($dictfile) | lines | wrap word | upsert len {|it| $it.word | split chars | length} | where len <= ($word_length) | get ($randline1) | get word)
  let randword2 = (open ($dictfile) | lines | wrap word | upsert len {|it| $it.word | split chars | length} | where len <= ($word_length) | get ($randline2) | get word)
  let randword3 = (open ($dictfile) | lines | wrap word | upsert len {|it| $it.word | split chars | length} | where len <= ($word_length) | get ($randline3) | get word)

  # Mix it up a bit with random capitalization, upper-casing and lower-casing
  let ri1 = (random integer 1..3)
  let randword1 = (if $ri1 == 1 {
    ($randword1 | str capitalize)
  } else if $ri1 == 2 {
    ($randword1 | str upcase)
  } else {
    ($randword1)
  })
  
  let ri2 = (random integer 1..3)
  let randword2 = (if $ri2 == 1 {
    ($randword2 | str capitalize)
  } else if $ri2 == 2 {
    ($randword2 | str upcase)
  } else {
    ($randword2)
  })

  let ri3 = (random integer 1..3)
  let randword3 = (if $ri3 == 1 {
    ($randword3 | str capitalize)
  } else if $ri3 == 2 {
    ($randword3 | str upcase)
  } else {
    ($randword3)
  })

  # Sprinkle some symbols like salt bae
  let symbolchars = "!@#$%^&*()_-+[]"
  let symb1 = ($symbolchars  | split chars | get (random integer 0..14))
  let symb2 = ($symbolchars  | split chars | get (random integer 0..14))
  let symb3 = ($symbolchars  | split chars | get (random integer 0..14))
  let symb4 = ($symbolchars  | split chars | get (random integer 0..14))

  # Print some vars and stuff if debug flag is set
  if $debug {
    print $"(ansi bg_blue) ====== DEBUG INFO ====== (ansi reset)"
    print $"(ansi bg_purple) 🔔 Number of lines in dict with words under ($word_length) chars: (ansi reset)"
    print $numlines
    print $"(ansi bg_purple) 🔔 Randomly selected lines: (ansi reset)"
    print $randline1 $randline2 $randline3
    print $"(ansi bg_purple) 🔔 Words from selected lines: (ansi reset)"
    print $randword1 $randword2 $randword3
    print $"(ansi bg_purple) 🔔 Randomly selected symbols: (ansi reset)"
    print $symb1 $symb2 $symb3 $symb4
    print $"(ansi bg_green) 🔔 Generated password: (ansi reset)"
  }
  
  # Print the password
  print $"($symb1)(random integer 1..99)($randword1)($symb2)($randword2)($symb3)(random integer 1..99)($randword3)($symb4)"
}

def testpathvar1 [] {
  let randnum = (random integer 0..2)
  #let cpath = $"($randnum).x"
  [{x:0 y:5 z:1} {x:4 y:7 z:3} {x:2 y:2 z:0}] | get $randnum | get x
}

# error: resolved by assigning with double equals
def testmut1 [] {
  let ri1 = (random integer 1..3)
  let word1 = "nugget"
  if $ri1 == 1 {
    print ($word1 | str capitalize)
  } else if $ri1 == 2 {
    print ($word1 | str upcase)
  } else {
    print ($word1 | str downcase)
  }
}
# error: can't convert nothing to bool
def testmut2 [] {
  mut ri1 = (random integer 1..3)
  let word1 = "nugget"
  if $ri1 = 1 {
    print ($word1 | str capitalize)
  } else if $ri1 = 2 {
    print ($word1 | str upcase)
  } else {
    print ($word1 | str downcase)
  }
}
def testmut3 [] {
  let ri1 = (random integer 1..3)
  let word1 = "nugget"
  let word1 = (if $ri1 == 1 {
     ($word1 | str capitalize)
  } else if $ri1 == 2 {
     ($word1 | str upcase)
  } else {
     ($word1 | str downcase)
  })
  print $word1
}