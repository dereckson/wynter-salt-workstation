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
#   :: VCS
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
#
#   http://zshwiki.org/home/zle/bindkeys
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

bindkey -e

[[ $TERM == screen ]] && TERM=screen-256color

autoload zkbd
function zkbd_file() {
    [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
    [[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
    return 1
}

[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
keyfile=$(zkbd_file)
ret=$?
if [[ ${ret} -ne 0 ]]; then
    zkbd
    keyfile=$(zkbd_file)
    ret=$?
fi
if [[ ${ret} -eq 0 ]] ; then
    source "${keyfile}"
else
    printf 'Failed to setup keys using zkbd.\n'
fi
unfunction zkbd_file; unset keyfile ret

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

export WORDCHARS='*?_[]~=&;!#$%^(){}'

[[ -n "$key[Home]"      ]] && bindkey -- "$key[Home]"      beginning-of-line
[[ -n "$key[End]"       ]] && bindkey -- "$key[End]"       end-of-line
[[ -n "$key[Insert]"    ]] && bindkey -- "$key[Insert]"    overwrite-mode
[[ -n "$key[Backspace]" ]] && bindkey -- "$key[Backspace]" backward-delete-char
[[ -n "$key[Delete]"    ]] && bindkey -- "$key[Delete]"    delete-char
[[ -n "$key[Up]"        ]] && bindkey -- "$key[Up]"        up-line-or-beginning-search
[[ -n "$key[Down]"      ]] && bindkey -- "$key[Down]"      down-line-or-beginning-search
[[ -n "$key[Left]"      ]] && bindkey -- "$key[Left]"      backward-char
[[ -n "$key[Right]"     ]] && bindkey -- "$key[Right]"     forward-char

#   -------------------------------------------------------------
#   VCS
#
#   :: alias to git-achievements
#   :: vcs_info prompt
#
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias git=git-achievements
compdef git-achievements=git

setopt prompt_subst
autoload -Uz vcs_info

zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

vcs_info_wrapper() {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
    fi
}
RPROMPT=$'$(vcs_info_wrapper)'
