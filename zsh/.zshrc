# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
setopt autocd beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/anatoli/.zshrc'

autoload -Uz compinit
compinit
#
# End of lines added by compinstall
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

plugins+=(
  git 
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-completions
  colored-man-pages
  eza
  z
  zsh-vi-mode
)

# Aliases for eza (or exa)
alias eza='exa'
alias ls='eza --classify --icons --grid '
alias la='eza --classify --icons --grid -a'
alias ll='eza --classify --icons --grid -al'
alias lt='eza --tree'

# Aliases for k8s
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias klo='kubectl logs -f'
alias klof='kubectl logs -f --tail=100'

# Aliases for Ansible
alias ap='ansible-playbook'
alias av='ansible-vault'
alias ag='ansible-galaxy'

# basic cli alisaes
alias g='git'
alias d='docker'
alias t='tmux'
alias lg='lazygit'
alias tf='terraform'
alias nv='nvim'

# Setup fzf
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
fi

if [ -f /usr/share/fzf/completion.zsh ]; then
  source /usr/share/fzf/completion.zsh
fi

# Source zsh-syntaxhighlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Source zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# z
. /usr/share/z/z.sh

# zsh-vi-mode
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh


zvm_bindkey  viins 'jj' vi-cmd-mode

# Load zsh's completion system
autoload -Uz compinit
compinit

# Set vi mode
bindkey -v

# Use the Tab key for autocompletion in vi insert mode
bindkey -M viins '^I' expand-or-complete

export PAGER=most
export MANPAGER="most"

export EDITOR=vim

KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    case ${KEYMAP} in
        (vicmd)      BULLETTRAIN_PROMPT_CHAR="N" ;;
        (main|viins) BULLETTRAIN_PROMPT_CHAR="I" ;;
        (*)          BULLETTRAIN_PROMPT_CHAR="I" ;;
    esac
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

