
PASDOC=/home/roland/Documents/sources/pasdoc/bin/pasdoc
OUT=doc
FILES=files.txt

if [ -d $OUT ]
then
  rm -rf $OUT
fi

mkdir -p $OUT

ls -1 *.pas > $FILES

$PASDOC --output=$OUT --language=fr.utf8 --source=$FILES

rm -f $FILES
