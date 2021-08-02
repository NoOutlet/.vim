# aliases, obviously
alias la="ls -a"
alias vi="nvim"

# Git branch in right-side prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
BRANCH=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{magenta}[%b]%f'
zstyle ':vcs_info:*' enable git

PROMPT="%(?.%F{green}√.%F{red}?%?)%f %B%F{223}%2~%f%b$BRANCH%F{green}\$%f "

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit

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

export N_PREFIX="$HOME/.n"
export PATH="$N_PREFIX/bin:$PATH"
