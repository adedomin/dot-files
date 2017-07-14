OBJ = $(wildcard *)
OBJ := $(filter-out Makefile,$(OBJ))
OBJ_HOME = $(addprefix $(HOME)/,$(OBJ))

all:

$(HOME)/%: %
	cp -r $< $@

install: $(OBJ_HOME)
