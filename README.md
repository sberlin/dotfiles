# Contents
Each make target comes with a corresponding suffixed clean target, though purging entire block from files is not automated yet.

## tmux
Different configurations to improve working with [tmux](https://tmux.github.io)

Sources:
* [The Tao of tmux](https://leanpub.com/the-tao-of-tmux/read)
* Various Stack Overflow pages
* Terminal habits

Made to work with [KiTTY](http://www.9bis.net/kitty), a fork of [PuTTY](http://www.putty.org) to use with Windows. The necessary session options are documented in [this gist](https://gist.github.com/sberlin/cc71df9caf9d1b53219a2c30da29363d).

### Installation
```sh
$ make tmux
```

## tmux Solarized
Use tmux with the famous theme [Solarized](http://ethanschoonover.com/solarized)

Check out the implementations for various tools at [altercation/solarized](https://github.com/altercation/solarized)

Made to work with [KiTTY](http://www.9bis.net/kitty), a fork of [PuTTY](http://www.putty.org) to use with Windows. The necessary session options are documented in [this gist](https://gist.github.com/sberlin/cc71df9caf9d1b53219a2c30da29363d).

### Installation
```sh
$ make tmux_solarized
```

## r is for run
Executable to detach an application completely from shell with nohup. Also creates a symbolic link in `~/bin` and adds it to your path.

### Installation
```sh
$ make complete_r
```

### Usage
```sh
$ r gedit sample.txt
```

### Completion
Adds completion for custom script [r](#r-is-for-run)

Usage:
```sh
$ r ged[tab][tab]
gedbar          gedfoo          gedit
$ r gedit sam[tab][tab]
sambar.xml      samfoo.log      sample.txt
```

## gitconfig
Useful configurations for Git read from [gitconfig](gitconfig).

### Customize
The value part needs escaping:
```sh
$ git config --global --list | sed -r 's#^([^=]+)=(.+)$#\1=\x27\2\x27#g' | sort > gitconfig
```

### Installation
```sh
$ make gitconfig
$ make git_user_info
```

## Git User Info
Set name and mail adress for user

### Installation
```sh
$ make git_user_info USERNAME=user USERMAIL=user@example.com
```

## Unity Settings
Set font sizes and launcher apps defined in [unity_settings](unity_settings). Needs `gsettings` installed.

### Installation
```sh
$ make unity_settings
```

## IntelliJ IDEA

### Installation
Default installation directory is `/opt/workspace/<username>/opt`. Also creates a symbolic link in `~/bin` and adds it to your path.

```sh
$ make idea
```
