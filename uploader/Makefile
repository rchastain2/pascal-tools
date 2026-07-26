
SYNAPSE := $(HOME)/Documents/sources/synapse

PC := fpc
PFLAGS := -Mobjfpc -Sh
PFLAGS += -Fu$(SYNAPSE)
PFLAGS += -CX -Xs -XX

PROGRAM := uploader

$(PROGRAM): $(PROGRAM).pas configuration.pas
	$(PC) $(PFLAGS) $<

test: $(PROGRAM)
	./$(PROGRAM) files.txt

clean:
	@rm -fv *.o *.ppu $(PROGRAM)

install: $(PROGRAM)
	@cp -fv $< $(HOME)/.local/bin
