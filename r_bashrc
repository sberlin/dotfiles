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

