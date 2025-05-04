HISTFILE=~/.config/zsh/.histfile
HISTSIZE=5000
SAVEHIST=100000
setopt autocd extendedglob
unsetopt beep
bindkey -v

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
# time at right hand side
RPROMPT='%F{15}(%F{166}%D{%H:%M}%F{15})%f'

export PATH=$PATH:$HOME/.local/bin
export EDITOR=zed

# Fixing zsh history problems on multiple terminals
setopt inc_append_history
setopt share_history
setopt histignorealldups
