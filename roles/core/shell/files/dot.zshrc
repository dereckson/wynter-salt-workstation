#   -------------------------------------------------------------
#   Zsh configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-10-26
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Table of contents
#   -------------------------------------------------------------
#
#   :: Completions
#   :: History
#   :: Prompt
#   :: Background jobs
#   :: Compatibility with csh
#   :: SSH
#   :: Keys bindings
#
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Completions
#
#   This section has been prepared with compinstall
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' matcher-list ''
zstyle ':completion:*' max-errors 4
zstyle ':completion:*' substitute 1

autoload -Uz compinit
compinit

setopt extendedglob

#   -------------------------------------------------------------
#   History
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

#   -------------------------------------------------------------
#   Prompt
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

prompt='%B%/%b ] '

#   -------------------------------------------------------------
#   Background jobs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setopt notify

#   -------------------------------------------------------------
#   Compatibility with csh
#
#   makecheck / https://news.ycombinator.com/item?id=4201636
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setenv () {
    if [ "x$1" = "x" ] ; then
        echo "$0: environment variable name required" >&2
    elif [ "x$2" = "x" ] ; then
        echo "$0: environment variable value required" >&2
    else
        export $1=$2
    fi
}

unsetenv () {
    if [ "x$1" = "x" ] ; then
        echo "$0: environment variable name required" >&2
    else
        unset $1
    fi
}

#   -------------------------------------------------------------
#   SSH
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

source $HOME/bin/ssh-agent-session

#   -------------------------------------------------------------
#   Keys bindings
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

bindkey -e

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[2~" overwrite-mode
