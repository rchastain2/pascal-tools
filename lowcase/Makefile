
PFLAGS := -Mobjfpc -Sh
PFLAGS += -FUunits
PFLAGS += -CX -Xs -XX

program: lowcase

%: %.pas
ifeq ($(OS),Windows_NT)
	if not exist units mkdir units
else
	mkdir -p units
endif
	fpc $< $(PFLAGS)

clean:
	rm -f *.log units/*.o units/*.ppu
