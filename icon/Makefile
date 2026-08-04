
PPU := tmp

FLAGS := -Mobjfpc -Sh
FLAGS += -FU$(PPU)
FLAGS += -gl

SOURCES := $(filter-out rwico.pas,$(wildcard *.pas))
TARGETS := $(patsubst %.pas,%,$(SOURCES))

default: bmp2ico
.PHONY: clean

%: %.pas
	mkdir -p $(PPU)
	fpc $(FLAGS) $<

clean:
	rm -fv $(PPU)/*.o $(PPU)/*.ppu *.o *.ppu *.res
ifeq ($(OS),Windows_NT)
	rm -fv $(patsubst %.pas,%.exe,$(SOURCES))
else
	rm -fv $(TARGETS)
endif
