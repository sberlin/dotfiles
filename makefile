default: install

.PHONY: install clean \
	complete_r clean_complete_r \
	gitconfig clean_gitconfig \
	git_user_info clean_git_user_info \
	idea clean_idea

USER_WORKSPACE=/opt/workspace/$(shell id --user --name)

install: complete_r gitconfig git_user_info idea

clean: clean_complete_r clean_gitconfig clean_git_user_info clean_idea

complete_r:
	mkdir -p ~/bin
	cp r ~/bin/
	chmod +x ~/bin/r
	cat r_bashrc >> ~/.bashrc

clean_complete_r:
	rm -f ~/bin/r
	@echo "Please remove the following block from ~/.bashrc manually"
	@echo "---------------------------------------------------------"
	cat r_bashrc
	@echo "---------------------------------------------------------"

gitconfig:
	grep --extended-regexp --only-matching '^([^ ]+) (.+)$$' gitconfig \
		| xargs --verbose --no-run-if-empty --max-lines=1 git config --global

clean_gitconfig:
	grep --extended-regexp --only-matching '^([^ ]+)' gitconfig \
		| xargs --verbose --no-run-if-empty --max-lines=1 git config --global --unset

git_user_info:
	test -n "$(USERNAME)" && git config --global user.name $(USERNAME)
	test -n "$(USERMAIL)" && git config --global user.email $(USERMAIL)

clean_git_user_info:
	git config --global --unset user.name
	git config --global --unset user.email

idea:
	mkdir -p $(USER_WORKSPACE)/opt/ && \
	    wget --output-document=$(USER_WORKSPACE)/opt/idea.tar.gz \
	        https://download.jetbrains.com/idea/ideaIU-2017.2.1.tar.gz && \
	    tar xzf $(USER_WORKSPACE)/opt/idea.tar.gz -C $(USER_WORKSPACE)/opt/ && \
	    rm $(USER_WORKSPACE)/opt/idea.tar.gz

clean_idea:
	rm -rf $(shell dirname $(shell dirname $(USER_WORKSPACE)/opt/*/bin/idea.sh))

