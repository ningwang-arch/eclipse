#!/bin/bash

# start some nice programs
systemctl --user import-environment DISPLAY
xrdb -merge ~/.Xresources

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

systemctl --user start clipmenud.service

# see https://unix.stackexchange.com/a/295652/332452
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# see https://wiki.archlinux.org/title/GNOME/Keyring#xinitrc
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
# see https://github.com/NixOS/nixpkgs/issues/14966#issuecomment-520083836
mkdir -p "$HOME"/.local/share/keyrings

export QT_QPA_PLATFORMTHEME=qt5ct
# 设置fcitx
export LANG="zh_CN.UTF-8"
export LANGUAGE=zh_CN:en_US
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export AWT_TOOLKIT=MToolKit
export _JAVA_AWT_WM_NONREPARENTING=1
wmname LG3D

exec xautolock -time 10 -locker "~/.local/bin/lock" -corners ---- -cornerdelay 5 -cornerredelay 5 -cornersize 10 &

# nm-applet &
flameshot &
dunst &
goblocks &
exec ~/.local/bin/setWallpaper &

picom --experimental-backends &

fcitx5 &
