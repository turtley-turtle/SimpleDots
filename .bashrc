#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
	#export PS1='\[\e[1m\][\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;36m\]\w\[\e[0;1m\]]> \[\e[0m\]'
	export STARSHIP_CONFIG=~/.config/starship-tty.toml
	eval "$(starship init bash)"
	fastfetch --config ~/.config/fastfetch/config-tty.jsonc
else
	. /etc/os-release
	#export PS1='\[\e[1m\][\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;36m\]\w\[\e[0;1m\]]❯ \[\e[0m\]'
	export STARSHIP_CONFIG=~/.config/starship.toml
	eval "$(starship init bash)"
	if [ "$NAME" == "Arch Linux" ]; then
		fastfetch --logo ~/.logo-arch.png --logo-type kitty
	elif [ "$NAME" == "EndeavourOS" ]; then
		fastfetch --logo ~/.logo-endeavour.png --logo-type kitty
	else
		fastfetch
	fi
fi
