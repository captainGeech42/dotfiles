# Dotfiles

 This repo contains most of my personal dotfiles, and installs some common packages I depend on.

Supports:

* Debian-based distros
* RHEL-based distros
* Arch Linux
* macOS

Use at your own peril, this could be broken at any point in time.

If you use it on macOS, make sure the Xcode Command Line Tools are installed first (`xcode-select --install`).

## Install

```
$ curl -L zanderwork.com/dotfiles | bash
```

(that URL 302s to the install script, if you don't want to `curl | bash` then download the `install.sh` script and run it)
