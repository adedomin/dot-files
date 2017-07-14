OBJ = .eslintrc.yml .config/ .vim .vimrc .vimperatorrc .zshrc .tmux.conf .local/share/zsh-syntax-highlighting
DIRS = .local/share
OBJ_HOME = $(addprefix $(HOME)/,$(OBJ))

all:

$(DIRS):
	mkdir -P $@

$(HOME)/%: % | $(DIRS)
	cp -r $< $@

install: $(OBJ_HOME)
