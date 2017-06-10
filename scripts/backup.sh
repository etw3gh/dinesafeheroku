#!/bin/bash
# backs up downloads to raid array
ts=`date '+%s'`
bdir="/media/raid/raa"
zip -r "$bdir/downloads_backup_$ts.zip" downloads

# show result
ls -lah $bdir