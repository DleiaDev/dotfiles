# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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
