# Uploader

Program based on [Synapse](https://github.com/geby/synapse), which I use to upload files to my site.

## Usage

The program expects as parameter a file containing the paths of the files to be sent.

```bash
uploader filelist.txt
```

The login details and the path to the mirror folder are stored in the *~/uploader.cfg* file.

```
[.]
host=msegui.net
username=pmwevymq
password=xxxx
localdir=/home/roland/Documents/site
```

When this file does not exist, the program creates it with dummy data and terminates.

## Build

```bash
make SYNAPSE=/path/to/synapse/units
```
