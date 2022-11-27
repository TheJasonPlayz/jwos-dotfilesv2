#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:~/.emacs.d/bin/

alias ls='ls --color=auto'
alias emacs='emacs'
alias emacsc='emacsclient -c -a "emacs"'
alias em='emacs -nw'
alias emacsd='emacs --daemon'
alias recompx='xmonad --recompile && xmonad --restart'
alias vueinstall='npm install && codium . && npm run dev'
alias conky='conky -c ~/.config/conky/xmonad/doom-one-01.conkyrc'
PS1='[\u@\h \W]\$ '

# Automatically added by the Guix install script.
if [ -n "$GUIX_ENVIRONMENT" ]; then
    if [[ $PS1 =~ (.*)"\\$" ]]; then
        PS1="${BASH_REMATCH[1]} [env]\\\$ "
    fi
fi

