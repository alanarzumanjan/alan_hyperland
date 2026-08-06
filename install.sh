#!/bin/bash
# install.sh

REPO="/data/alan_home_ext/alan_hyperland"

mkdir -p ~/bin

ln -sf $REPO/config/hypr ~/.config/hypr
ln -sf $REPO/config/waybar ~/.config/waybar
ln -sf $REPO/config/kitty ~/.config/kitty
ln -sf $REPO/config/fish ~/.config/fish
ln -sf $REPO/config/starship.toml ~/.config/starship.toml

ln -sf $REPO/config/btop ~/.config/btop
ln -sf $REPO/config/flameshot ~/.config/flameshot
ln -sf $REPO/config/imv ~/.config/imv
ln -sf $REPO/config/mpd ~/.config/mpd
ln -sf $REPO/config/ncmpcpp ~/.config/ncmpcpp
ln -sf $REPO/config/nvim ~/.config/nvim
ln -sf $REPO/config/ranger ~/.config/ranger
ln -sf $REPO/config/redshift ~/.config/redshift
ln -sf $REPO/config/rofi ~/.config/rofi
ln -sf $REPO/config/zathura ~/.config/zathura

ln -sf $REPO/dotfiles/.bashrc ~/.bashrc
ln -sf $REPO/dotfiles/.gitconfig ~/.gitconfig

ln -sf $REPO/bin/random-wallpaper.sh ~/bin/random-wallpaper.sh

echo "✅ All done! Please restart your session to apply the changes."