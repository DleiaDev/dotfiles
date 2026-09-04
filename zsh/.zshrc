# NVM
if [[ "$(uname)" == "Darwin" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
elif [[ "$(uname)" == "Linux" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# my programs
export PATH="$HOME/bin:$PATH"

# nvim
if [[ "$(uname)" == "Darwin" ]]; then
    NVIM=/opt/homebrew/bin/nvim
else
    NVIM=/usr/bin/nvim
fi
alias nvim=$NVIM
export EDITOR=$NVIM
export VISUAL=$NVIM

# man
export MANPAGER="$NVIM +Man!"
export MANWIDTH=999

# cargo
export PATH="$HOME/.cargo/bin:$PATH"

# xcaddy
XCADDY="$HOME/go/bin/xcaddy"
alias xcaddy=$XCADDY

# luamake
alias luamake="$HOME/.local/share/nvim/external/lua-language-server/3rd/luamake/luamake"

# flyctl
alias flyctl="$HOME/.fly/bin/flyctl"

# wezterm (flatpak, fedora only)
if [[ "$(uname)" == "Linux" ]]; then
    alias wezterm='flatpak run org.wezfurlong.wezterm'
fi

# colima (mac only)
if [[ "$(uname)" == "Darwin" ]]; then
    export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
fi

# Add .local/bin to path (Kiro installed there)
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/markoilic/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
