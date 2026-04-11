# Environment
export GTK_THEME=Adwaita-dark
export GTK_APPLICATION_PREFER_DARK_THEME=1
export XDG_RUNTIME_DIR=/run/user/$(id -u)
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR
export PATH="/bin/zig:/home/werdl/.local/bin:/home/werdl/.cargo/bin:$PATH"
export LANG=en_GB.UTF-8
alias ls='ls --color=auto'
alias ip='ip --color=auto'

set --le-predict

export HISTFILE=~/.zsh_history

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

bindkey -e

bindkey '^[[3~' delete-char  # bind the delete key

# ------------------------
# Zsh PS1 equivalent
# ------------------------

autoload -U colors && colors

setopt PROMPT_SUBST  # allow command substitution in prompt

PROMPT='%F{magenta}┌─[%F{green}%n%f%F{magenta}@%f%F{cyan}%m%f%F{magenta}] - [%F{yellow}${PWD/#$HOME/~}%f%F{magenta}] - [%f%F{blue}%*%f%F{magenta}] - [%f%(?.%F{green}.%F{red})%?%f%F{magenta}]
└─[%f%F{cyan}$%f%F{magenta}]%f '

export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
LISTMAX=1000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

setopt HIST_NO_STORE
setopt HIST_IGNORE_SPACE

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Load autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Optional: make suggestion appear in same style (grey text)
# Do not let cursor inherit suggestion highlight


bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
