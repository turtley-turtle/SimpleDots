cat <<'EOF'
 ____  _                 _      ____        _       
/ ___|(_)_ __ ___  _ __ | | ___|  _ \  ___ | |_ ___ 
\___ \| | '_ ` _ \| '_ \| |/ _ \ | | |/ _ \| __/ __|
 ___) | | | | | | | |_) | |  __/ |_| | (_) | |_\__ \
|____/|_|_| |_| |_| .__/|_|\___|____/ \___/ \__|___/
                  |_|                                  
EOF

source /etc/os-release
echo "Dependencies:
1. SDDM             2. Kitty            3. Nerd Fonts       
4. Hyprland         5. Hyprlock         6. Hyprpaper
7. Hyprshot         8. Hyprtoolkit      9. Hypridle
10. Waybar          11. Rofi            12. Starship"

read -p "Do you want to install the dependencies? " answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Ok."
else
    echo "Then why did you run the script?"
    exit 1
fi

if [[ "$ID" == "arch" || "$ID" == "endeavouros" || "$ID" == "cachyos" ]]; then
    echo "Installing dependencies"
    yay -S sddm kitty ttf-jetbrains-mono-nerd hyprland hyprlock hyprpaper hyprshot hyprtoolkit hypridle waybar rofi starship
    echo "Error or not error, i do not know"
elif [ "$ID" == "fedora" ]; then
    echo "Idk how to install the dependencies on Fedora, support will be added later"
    exit 1
elif [ "$ID" == "gentoo" ]; then
    echo "WHY DO YOU USE GENTOO!??!?!?"
    exit 1
elif [[ "$ID" == "opensuse" || "$ID" == "opensuse-tumbleweed" || "$ID" == "opensuse-leap" ]]; then
    echo "I never even touched openSUSE, i just know it's the chameleon OS or something"
    exit 1
elif [ "$ID" == "nixos" ]; then
    echo "I'll add support for this later... or never"
    exit 1
elif [ "$ID" == "android" ]; then
    echo "Bruh"
    exit 1
elif [ "$ID" == "debian" ]; then
    echo "Debian... no support. Now... you're on version Sid right? Because if you are, don't ever apt autoremove."
    exit 1
else
    echo "$NAME? As a script, i do not know what that is. (beep boop AI sounds)"
    exit 1
fi

for file in ~/.config/*; do
    if [[ "$file" == "hypr" || "$file" == "kitty" || "$file" == "waybar" || "$file" == "rofi" || "$file" == "starship.toml" || "$file" == "starship-tty.toml" || "$file" == "waypaper" || "$file" == "fastfetch" ]]; then
        echo "Backing up $file"
        mv "$file" "$file.bak"
    fi
done

echo "Backing up ~/.bashrc"
mv ~/.bashrc ~/.bashrc.bak
echo "Backing up /etc/sddm.conf"
mv /etc/sddm.conf /etc/sddm.conf.bak

echo "Copying files"
sudo cp -r SimpleSDDM /usr/share/sddm/themes/SimpleSDDM
sudo echo -e "[Theme]\nCurrent=SimpleSDDM\n\n[General]\nGreeterEnvironment=QML2_IMPORT_PATH=/usr/lib/qt/qml\n\n[Greeter]\nCommand=/usr/bin/sddm-greeter" >> /etc/sddm.conf
cp -r ./.config/hypr ~/.config/hypr
cp -r ./.config/kitty ~/.config/kitty
cp -r ./.config/rofi ~/.config/rofi
cp -r ./.config/starship.toml ~/.config/starship.toml
cp -r ./.config/starship-tty.toml ~/.config/starship-tty.toml
cp -r ./.config/waybar ~/.config/waybar
cp -r ./.bashrc ~/.bashrc
cp ./.local/bin ~/.local/bin
cp ./wallpapers ~/Pictures/wallpapers

echo "Done, just log out =D"
