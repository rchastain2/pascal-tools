# PasClean

Directory Cleaner.

## Description

Command line deleting in a directory tree all files whose name matches a regular expression provided by the user.

## Usage

Open a terminal and enter:

  `clean [directory]`

If no directory is specified, the program cleans the current directory.

The regular expression is stored in *cleaner.ini*. If that file doesn't exist, the program creates one with a default regular expression, and stops.

The default regular expression (1) will detect all files ending with one of the following extensions: \*.bak, \*.dbg, \*.o, \*.ppu.

The program prints to standard output the name of the deleted files.

(1) `^(.+\.bak|.+\.dbg|.+\.o|.+\.ppu)$`

## Compilation

You need the Free Pascal compiler.

A *Makefile* is provided.

The repository also includes a [MSEide](https://github.com/mse-org/mseide-msegui) project (in case you wonder what is that \*.prj file).

## Warning

It's a program which deletes files without asking confirmation. So be sure that you know what you do!

The program has been tested only on Linux, but it should work elsewhere.
