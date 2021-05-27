# If not running interactively, don't do anything
[[ $- != *i* ]] && return

setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096
export ERL_AFLAGS="-kernel shell_history enabled"

# extended completions
if [ -d ~/.zsh/completion/src ]; then
  fpath=(~/.zsh/completion/src $fpath)
fi

autoload -Uz compinit
compinit

# makes color constants available
autoload -U colors
colors
export CLICOLOR=1

# Bash behavior for alt-left right arrows and alt-b(back word) alt-f(forward
# word)
autoload -U select-word-style
select-word-style bash
bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

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

export PATH="$HOME/bin:$PATH"

# for mac systems this will pickup homebrew, otherwise nice to have.
export PATH="/usr/local/bin:$PATH"

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# automatically switch to node version when changing directories.
# if undesired you can remove this behavior by placing
# `add-zsh-hook -d chpwd load-nvmrc`
# to your ~/.zshrc.user
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version;
  local nvmrc_path;
  node_version="$(nvm version)"
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version;
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# NOTE: You may place your own configurations in ~/.zshrc.user
[[ -f ~/.zshrc.user ]] && source ~/.zshrc.user
