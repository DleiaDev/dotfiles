#!/usr/bin/zsh

DOTFILES=$(pwd -P)

ln -sf $DOTFILES/kitty $HOME/.config/kitty
ln -sf $DOTFILES/nvim $HOME/.config/nvim
ln -sf $DOTFILES/wezterm $HOME/.config/wezterm
ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/harlequin/harlequin.toml $HOME/harlequin/harlequin.toml
