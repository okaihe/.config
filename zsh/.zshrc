# ----- PATHS
export PATH="$PATH:/Users/kaiherbst/tools/flutter/bin" # Flutter
export PATH="$PATH:$HOME/.pub-cache/bin" # Dart/Pub
export PATH="$PATH:/Users/kaiherbst/tools/php-cs-fixer/vendor/bin" # PHP Fixer

export JAVA_HOME="/opt/homebrew/Cellar/openjdk/23.0.2/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

if command -v fnm &> /dev/null; then # Node
  eval "$(fnm env --use-on-cd)"
fi

# ----- COMPLETION
autoload -Uz compinit
compinit -C 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
if [ -f "$ZDOTDIR/.ng-completion.zsh" ]; then
    source "$ZDOTDIR/.ng-completion.zsh"
fi

# ----- PROMPT & TOOLS
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# ----- ALIASES
alias svenv="source venv/bin/activate"
alias ls="ls -G"
alias ll="ls -la"
alias v="nvim"
alias reload="source $ZDOTDIR/.zshrc"
alias zshconfig="nano $ZDOTDIR/.zshrc"

# ----- PLUGINS
HOMEBREW_PREFIX="/opt/homebrew" 
# Grauenvorschau
if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
# Syntax Highlighting
if [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[path_prefix]='none'

# ----- KEYBINDINGS
bindkey '^ ' autosuggest-accept
bindkey '^@' autosuggest-accept
