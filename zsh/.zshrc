HISTFILE=~/.config/zsh/.histfile
HISTSIZE=5000
SAVEHIST=100000
setopt autocd extendedglob
unsetopt beep

bindkey -v

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~"  delete-char

export PATH=$PATH:$HOME/.local/bin:$HOME/.lmstudio/bin
export EDITOR=nvim
export GIT_EDITOR=nvim

# Fixing zsh history problems on multiple terminals
setopt inc_append_history
setopt share_history
setopt histignorealldups

# Alias: general
alias ..='cd ..'
alias la='ls -la'

alias wake_up='(cd source/ai_web && ./run.sh >/dev/null 2>&1) && cd ~'
alias kill_ai='pkill -f "open-webui"'

alias mklink='ln -s "$(pwd)" ~/$(basename "$(pwd)")'

alias merlin='(cd ~/source/merlin && uv run merlin) && cd ~'
alias update_mp3='rsync -av /home/devin/music/ /run/media/devin/3761-3261'

eval "$(starship init zsh)"
fastfetch
