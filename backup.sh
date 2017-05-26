#!/bin/bash
# backs up downloads to raid array
ts=`date '+%s'`
zip -r "/media/raid/raa/downloads_backup_$ts.zip" downloads