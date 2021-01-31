#!/bin/bash

trap "exit 1" TERM
TOP_PID=$$

log() {
	echo "[*] $1"
}

error() {
	echo "[!] $1" >&2
}

prompt() {
	if [[ ! -z "$DF_NOPROMPT" ]]; then
		log "autoaccepting prompt: $1?"
		return 0
	fi

	read -n1 -p "[?] $1 (Y/n)? " input <&1
	echo ""

	if [[ $input == "y" || $input == "" ]]; then
		return 0
	elif [[ $input == "n" ]]; then
		return 1
	else
		error "invalid input"
		prompt "$1"
	fi
}


get_os() {
	if [[ -z "$OSTYPE" ]]; then
		error "couldn't detect OS type, exiting"
		kill -s TERM $TOP_PID
	fi

	case $OSTYPE in
		linux*)
			local os="linux"
			;;
		darwin*)
			local os="macos"
			;;
		*)
			error "unsupported OS detected, exiting: $OSTYPE"
			kill -s TERM $TOP_PID
			;;
	esac

	echo $os
}

get_distro() {
	if [[ ! -f "/etc/os-release" ]]; then
		error "couldn't detect distro, exiting"
		kill -s TERM $TOP_PID
	fi

	. /etc/os-release

	case $ID in
		"ubuntu") ;&
		"debian")
			local distro="debian"
			;;
		"centos") ;&
		"fedora") ;&
		"rhel")
			local distro="rhel"
			case $VERSION_ID in
				"7") ;&
				"8") ;;
				*)
					error "unsupported version of RHEL-based distro: $VERSION_ID"
					kill -s TERM $TOP_PID
					;;
			esac
			;;
		"arch")
			local distro="arch"
			;;
		*)
			error "unsupported distro detected, exiting: $ID"
			kill -s TERM $TOP_PID
			;;
	esac

	echo $distro
}

os=$(get_os)

log "detected OS: $os"

if [[ $os == "linux" ]]; then
	distro=$(get_distro)
	log "detected distro: $distro"

	. /etc/os-release
fi

if [[ $os == "macos" ]]; then
	# check if brew is installed
	if [[ ! -f "/usr/local/bin/brew" ]]; then
		log "couldn't find existing brew install"

		prompt "would you like to install homebrew"
		if [[ $? -eq 0 ]]; then
			log "installing homebrew"

			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
			if [[ $? -ne 0 ]]; then
				error "homebrew install failed, please fix and then rerun this script"
				exit 1
			fi
		else
			error "please install homebrew and rerun this script"
			exit 1
		fi
	fi
fi

log "installing packages"

case $os in
	"macos")
		brew install -q tmux wget telnet jq gpg thefuck htop
		;;
	"linux")
		case $distro in
			"debian")
				sudo apt-get update -qq
				sudo apt-get install -qq -y --no-install-recommends tmux vim jq htop wget gpg zsh git
				;;
			"rhel")
				if [[ "$VERSION_ID" == "7" ]]; then
					sudo yum install -q -y epel-release
					sudo yum install -q -y tmux vim jq htop wget gpg zsh git python36
				elif [[ "$VERSION_ID" == "8" ]]; then
					sudo dnf install -q -y epel-release
					sudo dnf install -q -y tmux vim jq htop wget gpg zsh git python38
				fi
				;;
			"arch")
				if [[ ! -f "/usr/bin/trizen" ]]; then
					prompt "trizen not found, would you like to install it"

					if [[ $? -eq 0 ]]; then
						pushd $(mktemp -d) 2>&1 >/dev/null
						sudo pacman -Sqyu --noconfirm git base-devel
						git clone https://aur.archlinux.org/trizen.git
						cd trizen
						echo "y" | makepkg -si --noconfirm
						popd 2>&1 >/dev/null
					fi
				fi

				sudo pacman -Sqyu --noconfirm tmux vim jq htop wget gnupg zsh git python
				;;
		esac
		;;
esac


