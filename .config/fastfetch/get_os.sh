#!/usr/bin/env bash
if [[ "$(uname -s)" == "Linux" ]]; then
	source /etc/os-release
	case "$ID" in arch|fedora|gentoo|zorin|linuxmint|debian|ubuntu)
		echo "$ID"
		;;
	esac
elif [[ "$(uname -s)" == "Darwin" ]]; then
	echo "macos"
elif [[ "$(uname -s)" == "FreeBSD" ]]; then
	echo "freebsd"
fi
