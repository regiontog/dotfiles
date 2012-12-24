unsetopt appendhistory beep
setopt nobeep              # No beeping
setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
setopt AUTOCD              # cd by typing dirname
setopt cdablevars          # Follow variables which are dirnames
setopt interactivecomments # allow comments on cmd line.
setopt MULTIOS             # Allow multiple redirection echo 'a'>b>c
setopt CORRECT CORRECT_ALL # Try to correct command line spelling
setopt BANG_HIST           # Allow ! for accessing history
setopt NOHUP               # Don't HUP running jobs on logout.
setopt NOBGNICE            # Don't renice background jobs
setopt EXTENDED_GLOB       # Enable extended globbing

zmodload zsh/complist
autoload -Uz compinit
compinit

zstyle :compinstall filename '$XDG_CONFIG_HOME/zsh/zshrc'

zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' use-cache on
zstyle ':completion:*' users resolve
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion*:default' menu 'select=1'

# allow approximate matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' auto-description 'Specify: %d'
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' verbose true
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns \
'*?.(o|c~|zwc)' '*?~'

zstyle ':completion:*:javac:*' files '*.java'

zstyle ':completion:*:vi:*' ignored-patterns '*.(o|a|so|aux|dvi|log|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|pyc)'
zstyle ':completion:*:mate:*' ignored-patterns '*.(o|a|so|aux|dvi|log|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|pyc)'
zstyle ':completion:*:vim:*' ignored-patterns '*.(o|a|so|aux|dvi|log|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|pyc)'
zstyle ':completion:*:gvim:*' ignored-patterns '*.(o|a|so|aux|dvi|log|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|pyc)'

zstyle ':completion:*:less:*' ignored-patterns '*.(o|a|so|dvi|fig|out|class|pdf|ps|pyc)'
zstyle ':completion:*:zless:*' ignored-patterns '*.(o|a|so|dvi|fig|out|class|pdf|ps|pyc)'

zstyle ':completion:*:xpdf:*' files '*.pdf'
zstyle ':completion:*:tar:*' files '*.tar|*.tgz|*.tz|*.tar.Z|*.tar.bz2|*.tZ|*.tar.gz'

zstyle ':completion:*:xdvi:*' files '*.dvi'
zstyle ':completion:*:dvips:*' files '*.dvi'

# Group related matches:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:-command-:*:(commands|builtins|reserved-words-aliases)' group-name commands

zstyle ':completion:*:manuals' seperate-sections true
zstyle ':completion:*' list-separator '#'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

#- buggy
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
#-/buggy

zstyle ':completion:*:pacman:*' force-list always
zstyle ':completion:*:*:pacman:*' menu yes select

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always


autoload -Uz compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=$XDG_CONFIG_HOME/zsh/history
HISTSIZE=10000
SAVEHIST=10000
setopt autocd
bindkey -v

# Set term
if [ -n "$TMUX" ]; then
  export TERM=screen-256color
elif [ -e /lib/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi

# Set prompt
autoload -U colors && colors
unset PS1 PS2 PS3 PS4 PROMPT RPROMPT

d_col=${1:-'blue'}
b_col=${2-'yellow'}
n_tru=${3:-'blue'}
n_fal=${4:-'red'}

export PS1='%(?.%{$fg_bold[$n_tru]%}.%{$fg[$n_fal]%})%# %{$reset_color%}'
export RPROMPT='%{$fg_bold[$b_col]%}${vcs_info_msg_0_}%{$fg_bold[$d_col]%}%1~%{$reset_color%}'

# Variables
export BROWSER="firefox"
export PAGER="vimpager"
export EDITOR="vim"
export PATH="${PATH}:$HOME/bin"
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vimrc" | source $MYVIMRC'
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"

# Dircolors
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS

# Aliases
alias ls='ls --color -F'
alias ll='ls --color -lh'
alias spm='sudo pacman'
alias mkpkg='makepkg'
alias startx="startx $XINITRC"

# Run plugins
source $XDG_CONFIG_HOME/zsh/zsh-syntax-highlighting.zsh

### Launch tmux
#if [ $TERM != "screen-256color" ] && [  $TERM != "screen" ]; then
#  tmux new; exit
#fi
