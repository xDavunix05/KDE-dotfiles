# Auto Start Tmux
if [[ -z $TMUX ]]; then
  if ! tmux has-session -t Main 2>/dev/null; then
    tmux new-session -s Main
    exit
  fi
fi
# Options
setopt autocd promptsubst notify hist_ignore_dups hist_ignore_space
unsetopt list_packed list_types no_list_ambiguous nonomatch
HISTSIZE=15
SAVEHIST=10

# My aliases
alias tm='tmux'
alias jl='journalctl'
alias clr='clear'

alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gr='git remote'
alias gl='git log --oneline --graph'

alias exploitdb='cd /usr/share/exploitdb/'
alias pydb='cd /usr/share/doc/python/html/'

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# Completion 
autoload -Uz compinit
if [[ -f ~/.zcompdump.zwc ]]; then
  compinit -u -C -d ~/.zcompdump
else
  compinit -u -C
  zcompile ~/.zcompdump
fi
zstyle ':completion:*' menu no
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '
%F{240}━━ %F{255}%d %F{240}━━%f
'
zstyle ':completion:*:warnings' format '
%F{red}No matches found.%f'

zstyle ':completion:*:messages' format '
%F{yellow}%d%f'

zstyle ':completion:*:corrections' format '
%F{blue}Did you mean: %d%f'

zstyle ':completion:*:warnings' format '
%F{red}No matches for %d%f'

zstyle ':completion:*:ignored' format '
%F{magenta}Ignored: %d%f'

# Prompt 
PROMPT_EOL_MARK=""              # hide EOL mark
WORDCHARS=${WORDCHARS//\/}      # remove '/' from word characters
PROMPT="[%2~%f]\$(git_branch) %B➤ %b"

git_branch() {
    local ref
    ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)
    if [[ -n $ref ]]; then
        echo " %F{cyan}${(U)ref} ⦿%f"
        return
    fi

    ref=$(git rev-parse --short HEAD 2>/dev/null) || return
    echo " %F{red}DETACHED:${(U)ref} ⦿%f"
}
# Update $PYTHON based on virtualenv
precmd() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        export PYTHON="$VIRTUAL_ENV/bin/python"
    else
        unset PYTHON
    fi
}

# Environment
export EDITOR=vim
export HISTFILE=$HOME/.history/.zsh_history
export MARIADB_HISTFILE=$HOME/.history/.mariadb_history
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"

# Language support
export LANG=en_US.UTF-8
export LANG=en_PH.UTF-8
