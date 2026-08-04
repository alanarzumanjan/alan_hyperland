# --- Prompt ---
parse_git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

parse_rel_path() {
  local p=$(pwd -P)
  if [[ "$p" == "$HOME" ]]; then
    echo ""
  elif [[ "$p" == $HOME/* ]]; then
    echo "${p/#$HOME\//}"
  else
    echo "$p"
  fi
}

PS1='\[\e[1;36m\]\u@\h\[\e[0m\]$(r=$(parse_rel_path); [ -n "$r" ] && echo " \e[0;37m$r")\[\e[33m\]$(b=$(parse_git_branch); [ -n "$b" ] && echo " ($b)")\[\e[0m\]\[\e[35m\] $(date +%H:%M)\[\e[0m\]\$ '

# --- Aliases ---
alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza -la --icons --color=always --group-directories-first --no-permissions --no-user --no-time'
alias lt='eza --tree --level=2 --icons'
alias la='eza -a --icons --color=always'
alias l='eza --icons --color=always'

alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias c='clear'

# Git
alias ga='git add .'

# Editor reload (Bash)
alias editbash='nano ~/.bashrc && source ~/.bashrc && echo -e "\e[32mBashrc reloaded\e[0m"'

# --- MPV Music Control (Background) ---
# Update the path below to match your actual music library
MPV_MUSIC_DIR="$HOME/Media/Music/Phonks"
alias play='mpv "$MPV_MUSIC_DIR" --shuffle --no-video --input-ipc-server=/tmp/mpv-socket >/dev/null 2>&1 & disown'
alias next='echo "playlist-next" | socat - /tmp/mpv-socket'
alias prev='echo "playlist-prev" | socat - /tmp/mpv-socket'
alias pause='echo "cycle pause" | socat - /tmp/mpv-socket'
alias mstop='killall mpv'

# --- History ---
HISTSIZE=50000
HISTFILESIZE=500000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend 2>/dev/null

add_to_prompt_command() {
  case ";$PROMPT_COMMAND;" in *";$1;"*) : ;; *) PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }$1" ;; esac
}
__pc_hist_sync() { history -a; history -c; history -r; }
add_to_prompt_command __pc_hist_sync

# --- System & Package Management (Arch) ---
alias orphans='pacman -Qtdq'
alias search='pacman -Ss'
alias remove='sudo pacman -Rns'
alias clean='sudo pacman -Rns $(pacman -Qtdq 2>/dev/null) 2>/dev/null || true'
alias download='sudo pacman -S'
alias stop='sudo systemctl poweroff'

update() {
  local NO_AUR=0 CLEAN=0 FORCE=0
  while (( "$#" )); do
    case "$1" in
      --no-aur) NO_AUR=1 ;;
      --clean) CLEAN=1 ;;
      --force-refresh) FORCE=1 ;;
      *) echo -e "\e[31mUnknown option:\e[0m $1"; return 2 ;;
    esac
    shift
  done

  local pac_flags="-Syu --noconfirm"
  [[ $FORCE -eq 1 ]] && pac_flags="-Syyu --noconfirm"

  echo -e "\e[36m==> Pacman update\e[0m"
  sudo pacman $pac_flags || { echo -e "\e[31mPacman update failed\e[0m"; return 1; }

  if [ $NO_AUR -eq 0 ]; then
    if command -v paru >/dev/null 2>&1; then
      echo -e "\e[36m==> AUR update (paru)\e[0m"
      paru -Syu --noconfirm || echo -e "\e[31mAUR update failed\e[0m"
    elif command -v yay >/dev/null 2>&1; then
      echo -e "\e[36m==> AUR update (yay)\e[0m"
      yay -Syu --noconfirm || echo -e "\e[31mAUR update failed\e[0m"
    else
      echo -e "\e[33mAUR helper not found\e[0m"
    fi
  else
    echo -e "\e[33mAUR skipped\e[0m"
  fi

  if [ $CLEAN -eq 1 ]; then
    echo -e "\e[36m==> Cleaning orphan packages\e[0m"
    local orph
    orph=$(pacman -Qtdq 2>/dev/null || true)
    if [ -n "$orph" ]; then
      sudo pacman -Rns $orph --noconfirm
      echo -e "\e[32mOrphan packages removed\e[0m"
    else
      echo -e "\e[32mNo orphans found\e[0m"
    fi
  fi

  if command -v flatpak >/dev/null 2>&1; then
    echo -e "\e[36m==> Flatpak update\e[0m"
    flatpak update -y || echo -e "\e[31mFlatpak update failed\e[0m"
  else
    echo -e "\e[33mFlatpak not installed\e[0m"
  fi

  echo -e "\e[32mUpdate completed\e[0m"
}

# --- Docker ---
alias docon='sudo systemctl start docker.socket docker.service && docker info --format "{{.ServerVersion}}" && echo "Docker: up"'
alias docoff='sudo systemctl stop docker.service docker.socket && echo "Docker: down"'
alias docclean='containers=$(docker ps -aq); [ -n "$containers" ] && docker stop $containers && docker rm -f $containers; images=$(docker images -aq); [ -n "$images" ] && docker rmi -f $images; docker system prune -a --volumes -f'
alias docrun='docclean && docker compose build --no-cache && docker compose up -d'

# --- Editors / Configs ---
alias waybar_edit='nano ~/.config/waybar/config.jsonc'
alias waybar_style='nano ~/.config/waybar/style.css'
alias hypconf='nano ~/.config/hypr/hyprland.lua'
alias hypup='hyprctl reload'

# --- Environment Variables ---
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:/usr/local/go/bin"

# Android SDK
export ANDROID_HOME="/data/Android/Sdk"
export ANDROID_SDK_ROOT="/data/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"

# Go
export GOPATH="/data/go"
export PATH="$PATH:$GOPATH/bin"

# Flutter
export PATH="$PATH:/data/flutter/bin"

# NPM global
export PATH="$HOME/.npm-global/bin:$PATH"

# Arduino
export ARDUINO_DIRECTORIES_DATA="/data/.arduino15"

# Other
export CHROME_EXECUTABLE="/usr/bin/chromium"

# Disable color for ls (eza works without this, but good to have)
eval "$(dircolors -b)"

# --- Custom Paths & Secrets ---
if [ -f "$HOME/.openclaw/completions/openclaw.bash" ]; then
  source "$HOME/.openclaw/completions/openclaw.bash"
fi

# VPN Example (Keep this commented out for GitHub safety, uncomment locally)
# alias vpn_start='sudo openvpn --config $HOME/Documents/servers/vpn_config.ovpn'

# Python Virtual Environment
alias interpreter='source ~/oi-venv/bin/activate 2>/dev/null && interpreter -y'