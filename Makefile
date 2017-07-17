OBJ = .eslintrc.yml .config/gtk-3.0 .vim .vimrc .vimperatorrc .zshrc .tmux.conf .local/share/zsh-syntax-highlighting
DIRS = $(HOME)/.local/share $(HOME)/.config
OBJ_HOME = $(addprefix $(HOME)/,$(OBJ))

all:

$(DIRS):
	mkdir -p $@

$(HOME)/%: % | $(DIRS)
	cp -r $< $@

install: $(OBJ_HOME)
