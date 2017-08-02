default: install

.PHONY: install clean complete_r gitconfig clean_complete_r clean_gitconfig

install: complete_r gitconfig

clean: clean_complete_r clean_gitconfig

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

