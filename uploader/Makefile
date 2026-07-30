
SYNAPSE := $(HOME)/Documents/sources/synapse
SIMPLELOG := simplelog

PC := fpc
PFLAGS := -Mobjfpc -Sh
PFLAGS += -Fu$(SYNAPSE)
PFLAGS += -Fu$(SIMPLELOG)/src
PFLAGS += -CX -Xs -XX

PROGRAM := uploader

$(PROGRAM): $(PROGRAM).pas configuration.pas $(SIMPLELOG)
	$(PC) $(PFLAGS) $<

$(SIMPLELOG):
	git clone https://github.com/ikelaiah/simplelog-fp.git $@

clean:
	@rm -fv *.o *.ppu $(PROGRAM)

install: $(PROGRAM)
	@cp -fv $< $(HOME)/.local/bin
