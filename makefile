default: install

.PHONY: install clean \
        complete_r complete_r_clean \
        gitconfig gitconfig_clean \
        git_user_info git_user_info_clean \
        idea idea_clean \
        unity_settings unity_settings_clean

USER_WORKSPACE=/opt/workspace/$(shell id --user --name)

install: complete_r gitconfig git_user_info idea unity_settings

clean: complete_r_clean gitconfig_clean git_user_info_clean idea_clean unity_settings_clean

complete_r:
	mkdir --parents ~/bin
	cp r ~/bin/
	chmod +x ~/bin/r
	cat r_bashrc >> ~/.bashrc

complete_r_clean:
	rm --force ~/bin/r
	@echo "Please remove the following block from ~/.bashrc manually"
	@echo "---------------------------------------------------------"
	cat r_bashrc
	@echo "---------------------------------------------------------"

gitconfig:
	grep --extended-regexp --only-matching '^([^ ]+) (.+)$$' gitconfig \
		| xargs --verbose --no-run-if-empty --max-lines=1 git config --global

gitconfig_clean:
	grep --extended-regexp --only-matching '^([^ ]+)' gitconfig \
		| xargs --verbose --no-run-if-empty --max-lines=1 git config --global --unset

git_user_info:
	test -n "$(USERNAME)" && git config --global user.name $(USERNAME)
	test -n "$(USERMAIL)" && git config --global user.email $(USERMAIL)

git_user_info_clean:
	git config --global --unset user.name
	git config --global --unset user.email

idea:
	mkdir --parents $(USER_WORKSPACE)/opt/ && \
	    wget --progress=dot:giga --output-document=$(USER_WORKSPACE)/opt/idea.tar.gz \
	        https://download.jetbrains.com/idea/ideaIU-2017.2.1.tar.gz && \
	    tar xzf $(USER_WORKSPACE)/opt/idea.tar.gz --directory $(USER_WORKSPACE)/opt/ && \
	    rm $(USER_WORKSPACE)/opt/idea.tar.gz

idea_clean:
	rm --recursive --force $(shell dirname $(shell dirname $(USER_WORKSPACE)/opt/*/bin/idea.sh))

unity_settings:
	command -v gsettings &> /dev/null || ( echo "Install gsettings first" && exit )
	grep --extended-regexp --only-matching '^([^ ]+) ([^ ]+) (.*)$$' unity_settings | \
	    xargs --verbose --no-run-if-empty --max-lines=1 gsettings set

unity_settings_clean:
	command -v gsettings &> /dev/null || ( echo "Install gsettings first" && exit )
	grep --extended-regexp --only-matching '^([^ ]+) ([^ ]+)' unity_settings | \
	    xargs --verbose --no-run-if-empty --max-lines=1 gsettings reset

