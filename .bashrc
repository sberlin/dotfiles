#!/bin/bash

export HISTCONTROL=ignoredups:erasedups
export HISTTIMEFORMAT="%Y-%m-%d %T %z "
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -n"
export CDPATH=.:..

shopt -s histappend
shopt -s extglob

export PS1='\[\033[0;35m\]\t \[\033[0;32m\]\u\[\033[0m\]@\[\033[0;34m\]\h\[\033[0m\]:\[\033[0;33m\]\w \[\033[0;31m\]\\$\[$(tput sgr0)\] '

# Run applications in background and detach them completely
r()
{
  nohup "$@" >/dev/null 2>&1 &
}

# Completion for nohup-wrapper r
_r()
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  if [[ "$COMP_CWORD" -ge 2 ]]
  then
    COMPREPLY=( $(compgen -f -- ${cur}) )
  else
    COMPREPLY=( $(compgen -c -- ${cur}) )
  fi
  return 0
}

complete -F _r r

