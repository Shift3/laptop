# If not running interactively, don't do anything
[[ $- != *i* ]] && return

setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096
export ERL_AFLAGS="-kernel shell_history enabled"

# nice completion
autoload -Uz compinit
compinit

# makes color constants available
autoload -U colors
colors
export CLICOLOR=1

# Prompt Code
# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  current_branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')
  if [[ -n $current_branch ]]; then
    echo "%{$fg_bold[yellow]%}$current_branch%{$reset_color%}"
  fi
}

setopt promptsubst

# Allow exported PS1 variable to override default prompt.
if ! env | grep -q '^PS1='; then
  PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[red]%}%c%{$reset_color%}$(git_prompt_info) # '
fi

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# global envs
export VISUAL=vim
export EDITOR=$VISUAL

g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}
compdef g=git

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

export PATH="$HOME/bin:$PATH"

# for mac systems this will pickup homebrew, otherwise nice to have.
export PATH="/usr/local/bin:$PATH"

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

