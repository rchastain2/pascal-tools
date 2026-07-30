
SIMPLELOG := simplelog

PC := fpc
PFLAGS := -Mobjfpc -Sh
PFLAGS += -Fu$(SIMPLELOG)/src
PFLAGS += -CX -Xs -XX

PROGRAM := pasclean
SOURCES := inifile.pas search.pas

$(PROGRAM): $(PROGRAM).pas $(SOURCES) $(SIMPLELOG)
	$(PC) $(PFLAGS) $<

$(SIMPLELOG):
	git clone https://github.com/ikelaiah/simplelog-fp.git $@

clean:
	@rm -fv *.o *.ppu $(PROGRAM)

install: $(PROGRAM)
	@cp -fv $< $(HOME)/.local/bin
