# .zshenv is sourced on all invocations of the shell, unless the -f option is set.
# It should contain commands to set the command search path, plus other important
# environment variables. .zshenv should not contain commands that produce output
# or assume the shell is attached to a tty.

# Ensure path arrays are unique
typeset -gU cdpath fpath mailpath path

# Set ZDOTDIR if not already set
: ${ZDOTDIR:=$HOME}

# Ensure basic paths are set
path=(
  /opt/homebrew/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  $path
)

# Export PATH
export PATH