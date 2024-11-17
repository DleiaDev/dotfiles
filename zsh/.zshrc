
# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# nvim
NVIM=/home/marko/bin/nvim-0.10.0/bin/nvim
alias nvim=$NVIM
export EDITOR=$NVIM
export VISUAL=$NVIM

# man
export MANPAGER="$NVIM +Man!"
export MANWIDTH=999

# cargo
export PATH="$HOME/.cargo/bin:$PATH"

# xcaddy
XCADDY=/home/marko/go/bin/xcaddy
alias xcaddy=$XCADDY

# luamake
alias luamake=/home/marko/.local/share/nvim/external/lua-language-server/3rd/luamake/luamake

# flyctl
alias flyctl=/home/marko/.fly/bin/flyctl
