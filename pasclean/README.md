# PasClean

Program deleting in a directory all files whose name matches a regular expression provided by the user.

## Usage

```bash
pasclean [directory]
```

The regular expression is stored in *pasclean.ini*. If that file doesn't exist, the program creates one with default values, and stops.

```
[settings]
expr=^(.+\.bak|.+\.dbg|.+\.o|.+\.ppu)$
subdirs=True
```

The default regular expression will detect all files ending with one of the following extensions: \*.bak, \*.dbg, \*.o, \*.ppu.

## Compilation

```bash
make
```
