# .bashrc

# Settings
# --------

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Set function to run before prompt
PROMPT_COMMAND=set_prompt

# Set the display so that gitK can run
export DISPLAY=:0.0

# Set colors of ls output
eval $(dircolors -b /etc/DIR_COLORS)

# Disable scroll locking with Ctrl-S
stty -ixon

# Aliases
alias vi='vim'
alias ls='ls --color=tty --group-directories-first'
alias l='ls --color'

# Functions
# ---------

# function for setting prompt with git branch status indicator
function set_prompt {
# Shorten the path if it's too long (longer than $m)
  local p=$(pwd) b s m=30
  p=${p/#$HOME/\~}
  s=${#p}
  while [[ $p != "${p//\/}" ]]&&(($s>$m))
  do
    p=${p#/}
    [[ $p =~ \.?. ]]
    b=$b/${BASH_REMATCH[0]}
    p=${p#*/}
    ((s=${#b}+${#p}))
  done
  p="${b/\/~/~}${b+/}$p"

  # Fill in a git status data if in git repo
  mapfile -t l < <(git status --porcelain -b 2> /dev/null)
  # branch, commits ahead, commits behind, uncommitted changes indicator, indicator color
  local br="" la="" lb="" lc="" st='0' i
  if [ ${#l} != '0' ]; then
    br=${l[0]:3} && br=${br%...*}
    la=${l[0]#*[ahead } && la=${la%% *} && [[ ${la:(-1)} != '#' ]] && la=${la:0:${#la}-1} || la=""
    lb=${l[0]#*behind } && lb=${lb%% *} && [[ ${lb:(-1)} != '#' ]] && lb=${lb:0:${#lb}-1} || lb=""
    st='36'
    for i in "${l[@]:1}"; do
      [[ "$st" = '31' || ${i:1:1} != ' ' ]] && st='31' && lc='∂' || lc='∂'
    done

    # Set prompt variable with git indicator
    PS1="\[\e[33m\]$p\[\e[0;35m\][$br\[\e[0;32m\]$la\[\e[1;33m\]$lb\[\e[0m\]\[\e[1;${st}m\]$lc\[\e[0;35m\]]\[\e[1;32m\]\$\[\e[0m\] "
  else
    # Set prompt variable without git indicator
    PS1="\[\e[33m\]$p\[\e[1;32m\]\$\[\e[0m\] "
  fi
}

# A shortcut function that simplifies usage of xclip.
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "       echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}

# Copy contents of a file
function cbf() { cat "$1" | cb; }
