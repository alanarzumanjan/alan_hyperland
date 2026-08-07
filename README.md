# Alan Hyperland
(Test version, I am in process)

Personal configuration files for Arch Linux running the Hyprland window manager.

## Repository Structure

- `/bin` – Custom scripts for system actions (brightness, battery, fullscreen terminal, powermenu, wifi menu, color picker, etc.).
- `/config` – Apps configurations.

## Dependencies

Install the required packages to make these configs work properly:

```bash
sudo pacman -S hyprland waybar rofi kitty mpd mpc mpv socat brightnessctl curl eza git ttf-jetbrains-mono-nerd
```

You will also need a NetworkManager client (`nmcli`) for the Wi-Fi menu, and `pavucontrol` for PulseAudio controls. The Papirus icon theme is recommended.

## Installation

1. Clone this repository into your home directory:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
```

2. Copy the configuration folders to your `.config`:

```bash
cp -r ~/dotfiles/.config/* ~/.config/
```

3. Copy the provided `.bashrc` to your home directory, or manually append the aliases and functions you need:

```bash
cp ~/dotfiles/.bashrc ~/.bashrc
source ~/.bashrc
```

4. Make the scripts executable:

```bash
chmod +x ~/dotfiles/bin/*
```

5. If you use a custom location for your scripts (like `/data/alan_home_ext/alan_hyperland/bin`), update the paths in `waybar/config` and `.bashrc`.

## Usage

- **Hyprland:** Reload the configuration with `hyprctl reload`. Keybindings include `$mainMod + F` for the fullscreen Kitty terminal and `$mainMod + C` for the color picker.
- **Waybar:** The panel features clickable modules. Click the network icon to open the Rofi Wi-Fi menu, the power menu to shut down or reboot, and the calculator to open a floating calculator.
- **MPV Music Control:** Use the aliases `play`, `next`, `prev`, and `pause` to control music playing in the background via the MPV socket.

## Customization

- **MPD:** Update the `music_directory` and `playlist_directory` paths in `mpd.conf` to point to your actual music folder.
- **Backlight:** The Waybar backlight module expects the correct device (`amdgpu_bl2` is used as an example). Run `ls /sys/class/backlight/` to find your correct device name.
- **Scripts:** Some scripts in `bin/` reference absolute paths. If you place them in a different folder, adjust the paths accordingly.
