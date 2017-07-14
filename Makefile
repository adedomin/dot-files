OBJ = .eslintrc.yml .config/ .vim .vimrc .vimperatorrc .zshrc .tmux.conf
OBJ_HOME = $(addprefix $(HOME)/,$(OBJ))

all:

$(HOME)/%: %
	cp -r $< $@

install: $(OBJ_HOME)
