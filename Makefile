OBJ = .eslintrc .config/ .vim .vimrc .vimperatorrc .zshrc .tmux.config
OBJ_HOME = $(addprefix $(HOME)/,$(OBJ))

all:

$(HOME)/%: %
	cp -r $< $@

install: $(OBJ_HOME)
