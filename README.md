# Contents
Each make target comes with a corresponding suffixed clean target, though cleaning your .bashrc is not automated yet.

## Targets
install/server_install:
* [complete_r](#r-is-for-run)
* [gitconfig](#gitconfig)
* [git_user_info](#git-user-info)

desktop_install:
* [unity_settings](#unity-settings)
* [idea](#intellij-idea)

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
