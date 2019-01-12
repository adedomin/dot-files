config_home = .config
data_home = .local/share
objects = $(config_home)/zsh/zshrc \
	      $(config_home)/vim/init.vim \
	      $(config_home)/tmux/tmux.conf \
	      $(config_home)/eslint/eslintrc.yml \
	      $(data_home)/vim/autoplay/plug.vim \
	      $(shell find $(config_home)/gtk-3.0 -type f) \
	      $(shell find $(data_home)/zsh-syntax-highlighting -type f) \
	      $(shell find $(data_home)/zsh-completions -type f)

# where -- is a separator
symlinks = $(HOME)/.zshrc--$(HOME)/$(config_home)/zsh/zshrc \
	       $(HOME)/.vimrc--$(HOME)/$(config_home)/vim/init.vim \
	       $(HOME)/.tmux.conf--$(HOME)/$(config_home)/tmux/tmux.conf \
	       $(HOME)/.eslintrc.yml--$(HOME)/$(config_home)/eslint/eslintrc.yml

symlink_targets = \
	$(foreach sym,$(symlinks),$(word 1,$(subst --, ,$(sym))))


dirs = $(HOME)/$(config_home)/zsh/custom \
	   $(HOME)/$(config_home)/vim/custom

obj_home = $(addprefix $(HOME)/,$(objects))

all:

$(dirs):
	mkdir -p $@

$(HOME)/%: % | $(dirs)
	install -D $< $@

$(symlink_targets): | $(dirs)
	sh -c '[ -f "$$1" ] && ln -sf "$$1" "$$2"' _ \
		'$(patsubst $@--%,%,$(filter $@--%,$(symlinks)))' \
		'$@'

install: $(obj_home) \
	     $(symlink_targets)

run-update:
	git pull
	git submodule update --recursive --remote

update: run-update install
