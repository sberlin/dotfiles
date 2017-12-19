export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -n"
export CDPATH=.:..
export EDITOR=/usr/bin/vim

shopt -s histappend

