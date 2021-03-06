# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Use neovim or vim
EDITOR="vi"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

if [ "$COLORTERM" == "xfce4-terminal" ] ; then
  export TERM=xterm-256color
fi

if [ "$COLORTERM" == "gnome-terminal" ] ; then
  export TERM=xterm-256color
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes maven bin if it exists
if [ -d "$HOME/Applications/maven/bin" ] ; then
  PATH="$HOME/Applications/maven/bin:$PATH"
fi

# set PATH so it includes node bin if it exists
if [ -d "$HOME/Applications/node/bin" ] ; then
  PATH="$HOME/Applications/node/bin:$PATH"
fi

# set PATH so it includes user's npm bin if it exists
if [ -d "$HOME/.npm-global/bin" ] ; then
  PATH="$HOME/.npm-global/bin:$PATH"
fi

xset r rate 200 60

tabs 2

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

# Run the set_prompt function before showing the prompt
PROMPT_COMMAND=set_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

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
p=${b/\/~/\~}${b+/}$p

# Display user@hostname:pwd process
echo -ne "\033]0;${USER}@${HOSTNAME}: ${p}\007"
# Fill in a git status data if in git repo
mapfile -t l < <(git status --porcelain -b 2> /dev/null)
# branch, commits ahead, commits behind, uncommitted changes indicator, untracked files, indicator color, untracked color
local br="" la="" lb="" lc="" ld="" ln="" st='0' nt='0' dt='0' i
if [ ${#l} != '0' ]; then
  br=${l[0]:3} && br=${br%...*}
  la=${l[0]#*[ahead } && la=${la%% *} && [[ ${la:(-1)} != '#' ]] && la=${la:0:${#la}-1} || la=""
  lb=${l[0]#*behind } && lb=${lb%% *} && [[ ${lb:(-1)} != '#' ]] && lb=${lb:0:${#lb}-1} || lb=""
  st='36'
  nt='36'
  dt='36'
  for i in "${l[@]:1}"; do
    [[ "$lc" = '∂' || ${i:0:1} =~ [MRUC] || ${i:1:1} =~ [MRUC] ]] && lc='∂'
    [[ "$st" = '31' || ${i:1:1} == 'M' ]] && st='31'
    [[ "$ld" = '✗' || ${i:0:1} == 'D' || ${i:1:1} == 'D' ]] && ld='✗'
    [[ "$dt" = '31' || ${i:1:1} != ' ' ]] && dt='31'
    [[ "$ln" = '?' || ${i:0:1} == 'A' || ${i:1:1} == '?' ]] && ln='?'
    [[ "$nt" = '31' || ${i:1:1} == '?' ]] && nt='31'
  done

  # Set prompt variable with git indicator
  PS1="\[\e[33m\]$p\[\e[0;35m\][$br\[\e[0;32m\]$la\[\e[1;33m\]$lb\[\e[0m\]\[\e[1;${st}m\]$lc\[\e[1;${nt}m\]$ln\[\e[1;${dt}m\]$ld\[\e[0;35m\]]\[\e[1;32m\]\$\[\e[0m\] "
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

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Java stuff
export JAVA_HOME="/usr/java/jdk1.8.0_162"
export JDK_HOME="/usr/java/jdk1.8.0_162"
export JRE_HOME="/usr/java/jdk1.8.0_162/jre"

# Set TMOUT to disabled per usability requirements
export TMOUT=0
