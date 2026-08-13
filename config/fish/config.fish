# Fish config

starship init fish | source

# Aliases
alias ls="eza --icons=auto --sort=time"
alias ll="eza -lah --icons --no-permissions --sort=time"
alias la="eza -lah --icons=auto --sort=time"
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."
alias orphans="pacman -Qtdq"
alias search="pacman -Ss"
alias remove="sudo pacman -Rns"
alias clean="sudo pacman -Rns (pacman -Qtdq 2>/dev/null) 2>/dev/null || true"
alias up="update"
alias download="sudo pacman -S"
alias l="eza --icons --color=always"
alias lt="eza --tree --level=2 --icons"
alias grep="grep --color=auto"

# Git
alias gs="git status"
alias ga="git add ."
alias gc="git commit"

# Docker
alias dps="docker ps"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias docker="lazydocker"

# Hyprland
alias hypedit="nano ~/.config/hypr/hyprland.lua"
alias hypup="hyprctl reload"
alias hypshow="cat ~/.config/hypr/hyprland.lua"
alias gohyp="/data/alan_home_ext/alan_hyperland"
alias gorep="cd /data/Repositories"
alias home="cd /home/alan"

# Waybar
alias wayedit="nano ~/.config/waybar/config.jsonc"
alias waycss="nano ~/.config/waybar/style.css"

# Rofi
alias rofiedit="nano ~/.config/rofi/config.rasi"

# Update
alias update="sudo pacman -Syu"

# PATH
set -gx PATH $PATH ~/.dotnet/tools
set -gx PATH $PATH ~/flutter/bin
set -gx PATH $PATH /usr/local/go/bin
set -gx PATH $PATH ~/.npm-global/bin
set -gx GOPATH /data/go
set -gx ANDROID_HOME /data/Android/Sdk
set -gx ANDROID_SDK_ROOT /data/Android/Sdk
set -gx CHROME_EXECUTABLE /usr/bin/chromium

# Editor
set -gx EDITOR nano

# Reload fish
alias fishreload="source ~/.config/fish/config.fish"

# Music
alias music="ncmpcpp"
alias play="mpv ~/Media/Music/Phonks --shuffle --no-video --input-ipc-server=/tmp/mpv-socket >/dev/null 2>&1 & disown"
alias next="echo 'playlist-next' | socat - /tmp/mpv-socket"
alias prev="echo 'playlist-prev' | socat - /tmp/mpv-socket"
alias pause="echo 'cycle pause' | socat - /tmp/mpv-socket"
alias mstop="killall mpv && kilall mpd"

# Docker
alias docon="sudo systemctl start docker.socket docker.service && docker info --format '{{.ServerVersion}}' && echo 'docker: up'"
alias docoff="sudo systemctl stop docker.service docker.socket && echo 'docker: down'"

function docclean
    set containers (docker ps -aq)
    if test -n "$containers"
        docker stop $containers; docker rm -f $containers
    end
    set images (docker images -aq)
    if test -n "$images"
        docker rmi -f $images
    end
    docker system prune -a --volumes -f
end

alias docrun="docclean && docker compose build --no-cache && docker compose up -d"

# --- Waybar ---
alias waybar_show="cat ~/.config/waybar/config.jsonc"
alias waybar_style="nano ~/.config/waybar/style.css"
alias waybar_showstyle="cat ~/.config/waybar/style.css"

# Fun
alias rain="terminal-rain"
alias bit="cava"

# --- VPN ---
alias rus_vpn="sudo openvpn --config /home/alan/Documents/servers/vpn696556713.opengw.net_ddns_udp.ovpn"
alias vpnstatus="systemctl --user status protonvpn-autoconnect.service"
alias stop="sudo systemctl poweroff"

# --- Interpreter (Open Interpreter) ---
alias interpreter="source ~/oi-venv/bin/activate 2>/dev/null && interpreter -y"

function update
    set -l no_aur 0
    set -l clean 0
    set -l force 0

    for arg in $argv
        switch $arg
            case --no-aur
                set no_aur 1
            case --clean
                set clean 1
            case --force-refresh
                set force 1
            case '*'
                echo (set_color red)"unknown option: $arg"(set_color normal)
                return 2
        end
    end

    set -l pac_flags -Syu --noconfirm
    if test $force -eq 1
        set pac_flags -Syyu --noconfirm
    end

    echo (set_color cyan)"==> pacman update"(set_color normal)
    sudo pacman $pac_flags
    if test $status -ne 0
        echo (set_color red)"pacman failed"(set_color normal)
        return 1
    end

    if test $no_aur -eq 0
        if command -v paru >/dev/null 2>&1
            echo (set_color cyan)"==> AUR update (paru)"(set_color normal)
            paru -Syu --noconfirm
        else if command -v yay >/dev/null 2>&1
            echo (set_color cyan)"==> AUR update (yay)"(set_color normal)
            yay -Syu --noconfirm
        else
            echo (set_color yellow)"AUR helper not found"(set_color normal)
        end
    else
        echo (set_color yellow)"AUR skipped"(set_color normal)
    end

    if test $clean -eq 1
        echo (set_color cyan)"==> Cleaning orphans"(set_color normal)
        set -l orph (pacman -Qtdq 2>/dev/null)
        if test -n "$orph"
            sudo pacman -Rns $orph --noconfirm
            echo (set_color green)"orphan packages removed"(set_color normal)
        else
            echo (set_color green)"no orphans found"(set_color normal)
        end
    end

    if command -v flatpak >/dev/null 2>&1
        echo (set_color cyan)"==> flatpak update"(set_color normal)
        flatpak update -y
    else
        echo (set_color yellow)"flatpak not installed"(set_color normal)
    end

    echo (set_color green)"update done"(set_color normal)
end

fish_add_path /data/alan_home_ext/alan_hyperland/bin
