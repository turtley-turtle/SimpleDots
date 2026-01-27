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

if [[ "$NAME" == "Arch Linux" || "$NAME" == "EndeavourOS" || "$NAME" == "Manjaro" || "$NAME" == "CachyOS" ]]; then
    echo "Installing dependencies"
    yay -S --noconfirm sddm kitty ttf-jetbrains-mono-nerd hyprland hyprlock hyprpaper hyprshot hyprtoolkit hypridle waybar rofi starship
    echo "Error or not error, i do not know"
elif [ "$NAME" == "Fedora" ]; then
    echo "Idk how to install the dependencies on Fedora, support will be added later"
    exit 1
elif [ "$NAME" == "Gentoo Linux" ]; then
    echo "WHY DO YOU USE GENTOO!??!?!?"
    exit 1
elif [ "$NAME" == "openSUSE" ]; then
    echo "I never even touched openSUSE, i just know it's the chameleon OS or something"
    exit 1
elif [ "$NAME" == "NixOS" ]; then
    echo "I'll add support for this later"
    exit 1
elif [ "$NAME" == "Android" ]; then
    echo "Bruh"
    exit 1
elif [ "$NAME" == "Fuck Linux" ]; then # yes, fuck linux is a thing...
    echo "Bro uses a Linux distro made by a Windows user"
    exit 1
else
    echo "$NAME? Never heard of it or do not care enough to make a custom message"
    exit 1
fi

for file in ~/.config/*; do
    if [[ "$file" == "hypr" || "$file" == "kitty" || "$file" == "waybar" || "$file" == "rofi" || "$file" == "starship.toml" || "$file" == "starship-tty.toml" ]]; then
        echo "Backing up $file"
        mv "$file" "$file.bak"
    fi
done
echo "Backing up ~/.bashrc"
mv ~/.bashrc ~/.bashrc.bak
echo "Backing up /etc/sddm.conf"
mv /etc/sddm.conf /etc/sddm.conf.bak

echo "Copying files"
cp -r SimpleSDDM /usr/share/sddm/themes/SimpleSDDM
sudo echo -e "[Theme]\nCurrent=SimpleSDDM" >> /etc/sddm.conf
cp -r ./.config/hypr ~/.config/hypr
cp -r ./.config/kitty ~/.config/kitty
cp -r ./.config/rofi ~/.config/rofi
cp -r ./.config/starship.toml ~/.config/starship.toml
cp -r ./.config/starship-tty.toml ~/.config/starship-tty.toml
cp -r ./.config/waybar ~/.config/waybar
cp -r ./.bashrc ~/.bashrc

echo "Done, just log out =D"