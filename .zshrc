# The following lines were added by compinstall
setopt nobeep              # No beeping
setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
setopt AUTOCD              # cd by typing dirname
setopt cdablevars          # Follow variables which are dirnames
setopt interactivecomments # allow comments on cmd line.
# setopt SH_WORD_SPLIT     # split up var in "for x in *"
setopt MULTIOS             # Allow multiple redirection echo 'a'>b>c
setopt CORRECT CORRECT_ALL # Try to correct command line spelling
setopt BANG_HIST           # Allow ! for accessing history
setopt NOHUP               # Don't HUP running jobs on logout.
setopt NOBGNICE            # Don't renice background jobs
setopt EXTENDED_GLOB       # Enable extended globbing

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

# Group relatex matches:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:-command-:*:(commands|builtins|reserved-words-aliases)' group-name commands

zstyle ':completion:*:manuals' seperate-sections true
zstyle ':completion:*' list-separator '#'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zshhist
HISTSIZE=10000
SAVEHIST=10000
setopt autocd
unsetopt appendhistory beep
bindkey -v
# End of lines configured by zsh-newuser-install
#
if [ -n "$TMUX" ]; then
  export TERM=screen-256color
elif [ -e /lib/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi

autoload -U colors && colors

unset PS1 PS2 PS3 PS4 PROMPT RPROMPT

d_col=${1:-'blue'}
b_col=${2-'yellow'}
n_tru=${3:-'blue'}
n_fal=${4:-'red'}

PS1='%(?.%{$fg_bold[$n_tru]%}.%{$fg[$n_fal]%})%# %{$reset_color%}'
RPROMPT='%{$fg_bold[$b_col]%}${vcs_info_msg_0_}%{$fg_bold[$d_col]%}%1~%{$reset_color%}'
EDITOR=vim

PATH=${PATH}:$HOME/bin
export PATH

# Aliases
[ $(which pacing | wc -w) -eq 1 ] && alias pacman=pacing
alias ls='ls --color=auto'
alias mkpkg=makepkg
alias torr=transmission-gtk

source ~/.zsh/zsh-syntax-highlighting.zsh

### Launch tmux
if [ $TERM != "screen-256color" ] && [  $TERM != "screen" ]; then
  tmux new; exit
fi
