# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=999999
SAVEHIST=999999
setopt appendhistory autocd extendedglob notify
unsetopt beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "/home/$(id --user --name)/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

# /etc/inputrc
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[2~" quoted-insert
bindkey "^[[3~" delete-char
setopt hist_ignore_dups
alias h='history -f -999999 | less'

