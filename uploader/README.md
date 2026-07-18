# File uploader

A program that I use to upload files to my website.

## Usage

```bash
uploader filelist.txt
```

The login details and the location of the mirror directory are stored in *~/uploader.cfg*.

```
[.]
host=msegui.net
username=pmwevymq
password=xxxx
localdir=/home/roland/Documents/site
```

When the configuration file doesn't exist, the program creates one and stops.

## Build

```bash
make SYNAPSE=/path/to/synapse/units
```
