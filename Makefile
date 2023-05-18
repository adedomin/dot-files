config_home = $(XDG_CONFIG_HOME)
data_home = $(XDG_DATA_HOME)
objects = $(shell find .config/ -type f) \
		  $(shell find .local/ -type f) \

# where -- is a separator
symlinks = $(HOME)/.zshrc--$(config_home)/zsh/zshrc \
	       $(HOME)/.tmux.conf--$(config_home)/tmux/tmux.conf \

symlink_targets = \
	$(foreach sym,$(symlinks),$(word 1,$(subst --, ,$(sym))))

obj_home = $(addprefix $(HOME)/,$(objects))

all:

$(HOME)/%: %
	install -D $< $@

$(symlink_targets):
	sh -c '[ -f "$$1" ] && ln -sf "$$1" "$$2"' _ \
		'$(patsubst $@--%,%,$(filter $@--%,$(symlinks)))' \
		'$@'

install: $(obj_home) \
	     $(symlink_targets)
	     rm -f -- "$(XDG_CACHE_HOME)/zsh/zcompdump-"*


run-update:
	git pull
	git submodule update --recursive --remote

update: run-update install
