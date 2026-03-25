
PFLAGS := -Mobjfpc -Sh
ifdef FRENCH
PFLAGS += -dFRENCH
endif

demo: demo.pas calendar.pas config.pas
	fpc $(PFLAGS) $<

clean:
	@rm -fv *.o *.ppu

distclean: clean
	@rm -fv demo demo.exe
