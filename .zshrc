# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration
setopt prompt_subst
setopt extendedglob

prompt() {
  local NO_COMMITS='No commits yet on '
  STATUS=("${(@f)$(git status --porcelain -b 2> /dev/null)}")
  if [[ $? -eq 0 ]]; then
    BRANCHLINE=${STATUS[1]}
    BRANCH=${${BRANCHLINE:3}#$NO_COMMITS} # For new repos
    BRANCH=${${BRANCH}%%...*} # get $branch from "$branch...$remote/$rbranch"
    if [[ "${BRANCHLINE[-1]}" = ']' ]]; then # Branch is ahead or behind in commits
      COMMITS_DIFF=${${BRANCHLINE%]}##*\[}
      AHEAD="%B%F{28}${${(M)COMMITS_DIFF##ahead [0-9]##}#ahead }%b"
      BEHIND="%B%F{yellow}${${(M)COMMITS_DIFF%%behind [0-9]##}#behind }%b"
    fi
    if [[ $#STATUS -gt 1 ]]; then
      st="cyan"
      dt="cyan"
      nt="cyan"
      for LINE in "${STATUS[@]:1}"; do
        [[ "$CHANGES" = '∂' || ${LINE:0:1} =~ [MRUC] || ${LINE:1:1} =~ [MRUC] ]] && CHANGES='∂'
        [[ "$st" = 'red' || ${LINE:1:1} == 'M' ]] && st='red'
        [[ "$DELETES" = '✗' || ${LINE:0:1} == 'D' || ${LINE:1:1} == 'D' ]] && DELETES='✗'
        [[ "$dt" = 'red' || ${LINE:1:1} != ' ' ]] && dt='red'
        [[ "$NEWFILE" = '?' || ${LINE:0:1} == 'A' || ${LINE:1:1} == '?' ]] && NEWFILE='?'
        [[ "$nt" = 'red' || ${LINE:1:1} == '?' ]] && nt='red'
      done
      CHANGES="%B%F{$st}$CHANGES%b"
      DELETES="%B%F{$dt}$DELETES%b"
      NEWFILE="%B%F{$nt}$NEWFILE%b"
    fi

    GITSTATUS="%F{magenta}[$BRANCH$AHEAD$BEHIND$CHANGES$DELETES$NEWFILE%F{magenta}]%f"
  fi
  echo "%(?.%F{green}√.%F{red}?%?)%f %B%F{223}%2~%f%b$GITSTATUS%F{green}\$%f "
}

PROMPT='$(prompt)'
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vi="nvim"

# fnm
export PATH=/Users/squiggs/.fnm:$PATH
eval "$(fnm env --use-on-cd)"
