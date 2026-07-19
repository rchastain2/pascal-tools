# Uploader

Programme basé sur [Synapse](https://github.com/geby/synapse), que j'utilise pour envoyer des fichiers sur mon site.

## Usage

Le programme attend comme paramètre un fichier contenant le chemin des fichiers à envoyer.

```bash
uploader filelist.txt
```

L'emplacement distant est déduit de l'emplacement local.

Les informations de connexion et le chemin du dossier-miroir sont conservés dans le fichier *~/uploader.cfg*.

```
[.]
host=msegui.net
username=pmwevymq
password=xxxx
localdir=/home/roland/Documents/site
```

Quand ce fichier n'existe pas, le programme le crée avec des données factices et s'arrête.

## Compilation

```bash
make SYNAPSE=/path/to/synapse/units
```
