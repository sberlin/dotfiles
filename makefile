default: install

.PHONY: install clean \
        server_install server_clean \
        desktop_install desktop_clean \
        ssh ssh_clean \
        tmux tmux_clean \
        tmux_solarized tmux_solarized_clean \
        complete_r complete_r_clean \
        gitconfig gitconfig_clean \
        git_user_info git_user_info_clean \
        idea idea_clean \
        unity_settings unity_settings_clean \
        _user_bin_add _clean_file

SHELL=/bin/bash
USER_WORKSPACE=/opt/workspace/$(shell id --user --name)

install: server_install

server_install: ssh tmux tmux_solarized complete_r gitconfig git_user_info

desktop_install: unity_settings idea

clean: server_clean

server_clean: ssh_clean tmux_clean tmux_solarized_clean complete_r_clean gitconfig_clean git_user_info_clean

desktop_clean: unity_settings_clean idea_clean

ifeq ($(findstring $(HOME)/bin, $(PATH)),)
_user_bin_add:
	@echo "Prefix PATH with $(HOME)/bin"
	cat bin_bashrc >> $(HOME)/.bashrc
else
_user_bin_add:
	@echo "Directory $(HOME)/bin already in PATH"
endif

_clean_file:
	@echo "Please remove the following blocks manually"
	@echo "---------------------------------------------------------"
	@tail --verbose --lines=+1 -- $(FILES)
	@echo "---------------------------------------------------------"

ssh:
	ssh-keygen -q -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa

ssh_clean:
	rm --force ~/.ssh/id_rsa ~/.ssh/id_rsa.pub

tmux:
	cp tmux.conf ~/.tmux-import.conf
	echo "source-file ~/.tmux-import.conf" >> ~/.tmux.conf

tmux_clean:
	sed --in-place 's#^source-file ~/.tmux-import.conf$$##g' ~/.tmux.conf
	rm --force ~/.tmux-import.conf

tmux_solarized:
ifeq ($(USERNAME),)
	wget --output-document ~/.tmux-solarized.conf --no-verbose \
	    "https://raw.githubusercontent.com/seebi/tmux-colors-solarized/master/tmuxcolors-256.conf"
else
	wget --output-document ~/.tmux-solarized.conf --no-verbose \
	    "https://raw.githubusercontent.com/$(USERNAME)/tmux-colors-solarized/master/tmuxcolors-256.conf"
endif
	echo "source-file ~/.tmux-solarized.conf" >> ~/.tmux.conf
	echo "alias tmux=\"tmux -2\"" >> ~/.bashrc
	@echo "Restart your tmux with 'tmux kill-server' to reload configuration"

tmux_solarized_clean:
	sed --in-place 's#^source-file ~/.tmux-solarized.conf$$##g' ~/.tmux.conf
	sed --in-place 's#^alias tmux="tmux -2"$$##g' ~/.bashrc
	rm --force ~/.tmux-solarized.conf
	@echo "Restart your tmux with 'tmux kill-server' to reload configuration"

complete_r: _user_bin_add
	mkdir --parents $(HOME)/bin
	cp r $(HOME)/bin/
	chmod +x $(HOME)/bin/r
	cat r_bashrc >> $(HOME)/.bashrc

complete_r_clean: FILES="bin_bashrc r_bashrc"
complete_r_clean: _clean_file
	rm --force $(HOME)/bin/r

gitconfig:
	sed --regexp-extended 's/^([^=]+)=(.+)$$/\1 \2/g' gitconfig \
		| xargs --verbose --no-run-if-empty --max-lines=1 git config --global

gitconfig_clean:
	sed --regexp-extended 's/^([^=]+)=(.+)$$/\1/g' gitconfig \
		| xargs --verbose --no-run-if-empty --max-lines=1 git config --global --unset

git_user_info:
	test -n "$(USERNAME)" && git config --global user.name $(USERNAME)
	test -n "$(USERMAIL)" && git config --global user.email $(USERMAIL)

git_user_info_clean:
	git config --global --unset user.name
	git config --global --unset user.email

idea: _user_bin_add
	mkdir --parents $(USER_WORKSPACE)/opt/ && \
	    wget --progress=dot:giga --output-document=$(USER_WORKSPACE)/opt/idea.tar.gz \
	        https://download.jetbrains.com/idea/ideaIU-2017.2.1.tar.gz && \
	    tar xzf $(USER_WORKSPACE)/opt/idea.tar.gz --directory $(USER_WORKSPACE)/opt/ && \
	    rm --force $(USER_WORKSPACE)/opt/idea.tar.gz && \
	    ln --verbose --symbolic --force $(USER_WORKSPACE)/opt/*/bin/idea.sh $(HOME)/bin/idea.sh

idea_clean: FILES="bin_bashrc"
idea_clean: _clean_file
	rm --recursive --force $(shell dirname $(shell dirname $(USER_WORKSPACE)/opt/*/bin/idea.sh))
	rm --force $(HOME)/bin/idea.sh

unity_settings:
	command -v gsettings &> /dev/null || ( echo "Install gsettings first" && exit )
	grep --extended-regexp --only-matching '^([^ ]+) ([^ ]+) (.*)$$' unity_settings | \
	    xargs --verbose --no-run-if-empty --max-lines=1 gsettings set

unity_settings_clean:
	command -v gsettings &> /dev/null || ( echo "Install gsettings first" && exit )
	grep --extended-regexp --only-matching '^([^ ]+) ([^ ]+)' unity_settings | \
	    xargs --verbose --no-run-if-empty --max-lines=1 gsettings reset

