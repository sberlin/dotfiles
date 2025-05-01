# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=999999
SAVEHIST=999999
setopt appendhistory hist_ignore_dups share_history autocd extendedglob notify hist_ignore_space
unsetopt beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "/home/$(id --user --name)/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
autoload -U +X bashcompinit && bashcompinit

# Run applications in background and detach them completely
r()
{
    nohup "$@" >/dev/null 2>&1 &
}

# Completion for nohup-wrapper r
compdef _command_names r
zstyle ':completion:*' special-dirs true

# oh-my-zsh
export ZSH=~/git/oh-my-zsh
ZSH_THEME="agnoster"
plugins=(
  common-aliases
  dnf
  firewalld
  git
  gradle
  kubectl
  mvn
  systemd
  vagrant
  vi-mode
  zsh-autosuggestions
  fzf-zsh-plugin
)
source $ZSH/oh-my-zsh.sh

# /etc/inputrc
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[2~" quoted-insert
bindkey "^[[3~" delete-char
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey "^U" kill-whole-line
bindkey "^Y" yank
bindkey "^[." insert-last-word
bindkey "^@" vi-cmd-mode
bindkey "^[f" vi-forward-blank-word
bindkey "^[F" vi-forward-word
bindkey "^[b" vi-backward-blank-word
bindkey "^[B" vi-backward-word
bindkey -M vicmd v edit-command-line

export EDITOR=vim
export LESS='-R -F'
export KEYTIMEOUT=1
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

alias autocomplete="compdef _gnu_generic $@"
alias h="fc -li 0 | ${PAGER:-less} ${LESS:--R} +G"
alias timestamp="date --iso-8601=seconds | tr ' :+' '-'"
alias -g S="| less ${LESS:--R} -S"

pandoc() { docker run --rm -v "$PWD":/data:z pandoc/core --standalone ${@}; }
pandoc-completion() { . <(pandoc --bash-completion); }
pandoc-css() {
    PANDOC_CSS=~/.pandoc.css.html
    test -f "${PANDOC_CSS}" || curl -fsSL "https://gist.githubusercontent.com/sberlin/e0600b5a85c7adb83df37539dc402bd9/raw/3a7c3a9058ccf7819292ced45be991ac2eaa3e1a/github-pandoc.css.html" > "${PANDOC_CSS}"
    docker run --rm -v "$PWD":/data:z -v "${PANDOC_CSS}":/pandoc.css.html:ro,z pandoc/core \
        --standalone --include-in-header "/pandoc.css.html" ${@}
}
complete -o filenames -o bashdefault -F _pandoc pandoc-css

trigger() {
    while true; do
        inotifywait -r -e modify "${1}"
        eval "${@:2}"
    done;
}

_git_current_branch() {
    export HEAD="$(git symbolic-ref --short HEAD 2&> /dev/null)";
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _git_current_branch

serve() {
    local destination="$(realpath ${1:-${PWD}})"
    local port="${2:-8080}"
    local name="serve-$(sha1hmac <<< "${destination}" | cut -d' ' -f1)"
    docker run --name "${name}" -d --rm -p "${port}":8080 -v "${destination}:/app:z" -u "$(id -u):0" bitnami/nginx:latest
    xdg-open http://localhost:"${port}"/
    docker attach "${name}"
}

try() {
    while :; do
        date +"%Y-%m-%d_%H-%M-%S"
        eval ${@[2,-1]}
        sleep ${@[1]}
    done
}

ascii() {
    curl https://artii.herokuapp.com/make?text=$1 | sed 's/ *$//g'
}

center() {
    sudo nsenter --net --uts --ipc --target "$(docker inspect --format {{.State.Pid}} $1)" ${@[2,-1]}
}

alias grepex="grep --recursive --exclude-dir=node_modules --exclude-dir=target --exclude-dir=.git --exclude-dir=.terraform"

sops() {
    docker run -it --rm -v "$PWD":/app:z -w /app -v "$HOME/.gnupg:/etc/gnupg:z" -e GNUPGHOME=/etc/gnupg --userns=keep-id ghcr.io/getsops/sops:v3.8.1 $@
}

dockerize() {
    alias "$1"="docker run -it --rm -v "\$PWD":/app:z -w /app $2 $1 ${@[3,-1]} "
}

dockerize pwsh powershell

alias datestr="date +'%Y-%m-%d_%H-%M-%S'"

ddg() {
    xdg-open "https://duckduckgo.com/?q=${@[@]}"
}
