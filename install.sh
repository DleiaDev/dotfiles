#!/usr/bin/zsh

DOTFILES=$(pwd -P)

ln -sf $DOTFILES/kitty $HOME/.config/kitty
ln -sf $DOTFILES/nvim $HOME/.config/nvim
ln -sf $DOTFILES/wezterm $HOME/.config/wezterm
ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/harlequin/harlequin.toml $HOME/harlequin/harlequin.toml
ln -sf $DOTFILES/git/.gitconfig $HOME/.gitconfig
ln -sfn $DOTFILES/bat $HOME/.config/bat
mkdir -p "$HOME/Library/Application Support/lazygit"
ln -sf $DOTFILES/lazygit/config.yml "$HOME/Library/Application Support/lazygit/config.yml"

bat cache --build
