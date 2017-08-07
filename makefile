default: install

.PHONY: install clean \
        complete_r complete_r_clean \
        gitconfig gitconfig_clean \
        git_user_info git_user_info_clean \
        idea idea_clean \
        unity_settings unity_settings_clean

SHELL=/bin/bash
USER_WORKSPACE=/opt/workspace/$(shell id --user --name)
USER_BIN_INCLUDE=if [ -d "$$HOME/bin" ] ; then\n    export PATH="$$HOME/bin:$$PATH"\nfi

install: complete_r gitconfig git_user_info unity_settings idea

clean: complete_r_clean gitconfig_clean git_user_info_clean unity_settings_clean idea_clean

ifeq ($(findstring $(HOME)/bin, $(PATH)),)
_user_bin_add:
	mkdir --parents $(HOME)/bin
	@echo "Prefix PATH with $(HOME)/bin"
	echo -e '$(USER_BIN_INCLUDE)' >> $(HOME)/.bashrc
else
_user_bin_add:
	@echo "Directory $(HOME)/bin already in PATH"
endif

complete_r: _user_bin_add
	cp r $(HOME)/bin/
	chmod +x $(HOME)/bin/r
	cat r_bashrc >> $(HOME)/.bashrc

complete_r_clean:
	rm --force $(HOME)/bin/r
	@echo "Please remove the following block from $(HOME)/.bashrc manually"
	@echo "---------------------------------------------------------"
	cat r_bashrc
	@echo -e "$(USER_BIN_INCLUDE)"
	@echo "---------------------------------------------------------"

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

idea_clean:
	rm --recursive --force $(shell dirname $(shell dirname $(USER_WORKSPACE)/opt/*/bin/idea.sh))
	rm --force $(HOME)/bin/idea.sh
	@echo "Please remove the following block from $(HOME)/.bashrc manually"
	@echo "---------------------------------------------------------"
	@echo -e "$(USER_BIN_INCLUDE)"
	@echo "---------------------------------------------------------"

unity_settings:
	command -v gsettings &> /dev/null || ( echo "Install gsettings first" && exit )
	grep --extended-regexp --only-matching '^([^ ]+) ([^ ]+) (.*)$$' unity_settings | \
	    xargs --verbose --no-run-if-empty --max-lines=1 gsettings set

unity_settings_clean:
	command -v gsettings &> /dev/null || ( echo "Install gsettings first" && exit )
	grep --extended-regexp --only-matching '^([^ ]+) ([^ ]+)' unity_settings | \
	    xargs --verbose --no-run-if-empty --max-lines=1 gsettings reset

