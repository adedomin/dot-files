OBJ = .zshrc \
	  .vimrc \
	  .tmux.conf \
      .eslintrc.yml \
	  .vimperatorrc \
	  $(shell find .config/gtk-3.0 -type f) \
	  $(shell find .vim/bundle/Vundle.vim -type f) \
	  $(shell find .local/share/zsh-syntax-highlighting -type f) \

DIRS = $(HOME)/.zshrc.d \
	   $(HOME)/.config/gtk-3.0 \
	   $(HOME)/.vim/bundle/Vundle.vim \
	   $(HOME)/.local/share/zsh-syntax-highlighting \

OBJ_HOME = $(addprefix $(HOME)/,$(OBJ))

all:

$(DIRS):
	mkdir -p $@

$(HOME)/%: % | $(DIRS)
	install -D $< $@

install: $(OBJ_HOME)
