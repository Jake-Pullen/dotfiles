HISTFILE=~/.config/zsh/.histfile
HISTSIZE=5000
SAVEHIST=100000
setopt autocd extendedglob
unsetopt beep

bindkey -v


bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey  "^[[3~"  delete-char

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
# time at right hand side
RPROMPT='%F{15}(%F{166}%D{%H:%M}%F{15})%f'

export PATH=$PATH:$HOME/.local/bin
export EDITOR=nvim
export GIT_EDITOR=nvim

# Fixing zsh history problems on multiple terminals
setopt inc_append_history
setopt share_history
setopt histignorealldups

# Aliases: git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'

fastfetch
