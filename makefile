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
	cp gitconfig ~/.gitconfig_custom
	git config --global include.path '~/.gitconfig_custom'

clean_gitconfig:
	git config --global --unset include.path || true
	rm -f ~/.gitconfig_custom

