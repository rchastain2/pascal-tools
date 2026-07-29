
PFLAGS := -Mobjfpc -Sh
PFLAGS += -CX -Xs -XX

PROGRAM := bmp2ico

default: $(PROGRAM)

%: %.pas
	fpc $(PFLAGS) $<

clean:
	rm -fv *.o

distclean: clean
	rm -fv $(PROGRAM)

DIR    := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SCRIPT := $(HOME)/.local/bin/$(PROGRAM)

install:
	echo "$(DIR)$(PROGRAM) \$$*" > $(SCRIPT)
	chmod +x $(SCRIPT)
