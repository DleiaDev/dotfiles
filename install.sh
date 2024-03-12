#!/usr/bin/env zsh

DOTFILES=$(pwd -P)

set -e

local overwrite_all=false
local backup_all=false
local skip_all=false

find $DOTFILES -maxdepth 2 -name 'links.prop' | while read linkfile
do
  cat $linkfile | while read line
  do
    local src=$(eval echo $line | cut -d = -f 1)
    local dst=$(eval echo $line | cut -d = -f 2)
    local dst_dir=$(dirname $dst)

    mkdir -p $dst_dir
    ln -sf $src $dst
  done
done

