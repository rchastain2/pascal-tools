# PasClean

Directory Cleaner.

## Description

Command line deleting in a directory tree all files whose name matches a regular expression provided by the user.

## Usage

```bash
pasclean [directory]
```

The regular expression is stored in *pasclean.ini*. If that file doesn't exist, the program creates one with a default regular expression, and stops.

The default regular expression will detect all files ending with one of the following extensions: \*.bak, \*.dbg, \*.o, \*.ppu:

```
^(.+\.bak|.+\.dbg|.+\.o|.+\.ppu)$
```

## Compilation

```bash
make
```

## Warning

The program deletes files without asking confirmation. Be sure that you know what you do!
