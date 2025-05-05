# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
NNTPSERVER='news.eternal-september.org' && export NNTPSERVER
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
export PATH="~/gitcl/lolcat-master/bin:~/gitcl/nyancat/src:$PATH:~/Downloads/FileZilla3/bin"
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
mkcd ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}
alias lt='du -sh * | sort -h'
alias hg='history|grep'
alias left='ls -t -1'
alias cpv='rsync -ah --info=progress2'
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
color_prompt=yes
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1="\n\[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;2m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;202m\]\h \[$(tput sgr0)\] : \[$(tput sgr0)\]\[\033[38;5;38m\]\d\[$(tput sgr0)\] [\[$(tput sgr0)\]\[\033[38;5;201m\]\A\[$(tput sgr0)\]] \n[\[$(tput sgr0)\]\[\033[38;5;51m\]\w\[$(tput sgr0)\]] \[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;129m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias qemu="qemu-system-x86_64"
alias i="sudo apt install"
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
alias gpt="python3 ~/chatgpt-cli/chatgpt.py"

(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/werdl/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH=":/home/werdl/node/node-v18.14.2-linux-x64/bin/:$PATH"
. "$HOME/.cargo/env"
alias grbpl='yt-dlp --yes-playlist https://www.youtube.com/playlist?list=PL7v3ZECc5evyLFqytu5Ajxk'
alias pip=pip3
export PATH=/home/werdl/node/node-v18.14.2-linux-x64/bin/:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/home/werdl/gitcl/lolcat-master/bin:/home/werdl/gitcl/nyancat/src:/home/werdl/node/node-v18.14.2-linux-x64/bin/:/home/linuxbrew/.linuxbrew/bin:/home/werdl/gitcl/lolcat-master/bin:/home/werdl/gitcl/nyancat/src:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/home/werdl/.cargo/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/home/werdl/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/snap/bin:/home/werdl/Downloads/FileZilla3/bin:/home/werdl/Downloads/FileZilla3/bin:~/werdl/coding/asm/clr
export PATH="$PATH:/home/werdl/cool-retro-term/"
export PATH="$HOME/opt/cross/bin:$PATH"
alias net="cd ~;./net.sh"
alias info="konsole -e \"tmuxinator sys\""
alias os="cd ~/coding/os/bare;code ."alias tetris="tetris-thefenriswolf.tetris"
