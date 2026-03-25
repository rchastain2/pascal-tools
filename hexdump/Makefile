
ifeq ($(OS),Windows_NT)
PREFIX := 
SUFFIX := .exe
else
PREFIX := ./
SUFFIX := 
endif

FLAGS := -Mobjfpc

hexdump: hexdump.pas
	fpc $< $(FLAGS)

demo: hexdump
	$(PREFIX)$< < LISEZMOI.txt

clean:
	rm -fv hexdump.o

distclean: clean
	rm -fv hexdump$(SUFFIX)
