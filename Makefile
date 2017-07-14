OBJ = .eslintrc.yml .config/ .vim .vimrc .vimperatorrc .zshrc .tmux.conf .local/share/zsh-syntax-highlighting
DIRS = $(HOME)/.local/share
OBJ_HOME = $(addprefix $(HOME)/,$(OBJ))

all:

$(DIRS):
	mkdir -p $@

$(HOME)/%: % | $(DIRS)
	cp -r $< $@

install: $(OBJ_HOME)
