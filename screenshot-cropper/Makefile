
BGRABITMAP := $(HOME)/Documents/sources/bgrabitmap/11_6_6/bgrabitmap
LAZARUS    := $(HOME)/Documents/sources/lazarus

PFLAGS := -Mobjfpc -Sh
PFLAGS += -Fu$(BGRABITMAP)
PFLAGS += -Fu$(LAZARUS)/components/lazutils
PFLAGS += -Fu$(LAZARUS)/components/freetype
PFLAGS += -dBGRABITMAP_DONT_USE_LCL

UNITS := units

PROGRAM := crop

default: $(PROGRAM)

%: %.pas $(UNITS) 
	fpc $(PFLAGS) $<

$(UNITS):
	mkdir $@

demo:
	cp -fv kcalc.png sample.png
	./crop sample.png

clean:
	rm -fv $(UNITS)/*.compiled $(UNITS)/*.o $(UNITS)/*.or $(UNITS)/*.ppu $(UNITS)/*.res
	rm -fv *.lps *.o

distclean: clean
	rm -fv $(PROGRAM)
	rm -rfv backup

DIR    := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SCRIPT := $(HOME)/.local/bin/$(PROGRAM)

install:
	echo "$(DIR)$(PROGRAM) \$$*" > $(SCRIPT)
	chmod +x $(SCRIPT)
