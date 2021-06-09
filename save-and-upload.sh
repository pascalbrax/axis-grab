#!/bin/bash

# saves webcam images every ~4 seconds and uploads latest image online.
# (c) 2021 pascal brax & friedrich b.raile

USER=user
PASSWORD=PassWord
URL=http://192.168.24.74:XXXX/jpg/image.jpg\?resolution=3072x1728
LOCATION=My room
FOLDER=/mnt/storage/axis
REMOTEHOST=user@web.host.example
REMOTEPATH=/var/www/img/webcam.jpg
TMPDIR=/tmp

while :
do
        #
        # SET UP TIME
        NOW=$(date +"%Y-%m-%d-%H-%M-%S")
        TODAY=$(date +"%Y-%m-%d")
        HUMAN=$(date +"%d.%m.%Y %H:%M")
        FILE=$NOW.jpg
        #
        # DOWNLOAD IMAGE FROM WEBCAM
        echo DOWNLOADING IMAGE...
        wget -q --show-progress --http-user=$USER --http-password=$PASSWORD $URL -O $TMPDIR/$FILE
        #
        # CREATE DAY FOLDER IF NOT EXIST
        if [ ! -d "$FOLDER/$TODAY" ]; then
                mkdir $FOLDER/$TODAY
        fi
        #
        # ADD TIMESTAMP AND SAVE FILE
        echo SAVING IMAGE...
        convert $TMPDIR/$FILE -gravity NorthWest -pointsize 24 \
        -fill black -annotate +3+3 "$LOCATION $HUMAN" \
        -fill white -annotate +2+2 "$LOCATION $HUMAN" $FOLDER/$TODAY/$FILE
        #
        # RESIZE AND UPLOAD
        echo RESIZING IMAGE...
        convert $TMPDIR/$FILE -resize 30% -gravity South -crop 100x70% \
        -pointsize 16 -gravity NorthWest \
        -fill black -annotate +11+291 "$LOCATION  $HUMAN" \
        -fill white -annotate +10+290 "$LOCATION  $HUMAN" $TMPDIR/$FILE
        # SSH (for upload on remote host)
        echo UPLOADING IMAGE...
        scp $TMPDIR/$FILE $REMOTEHOST:$REMOTEPATH
        # DELETE IMAGE AND WAIT
        echo WAITING...
        sleep 2s
        rm $TMPDIR/$FILE

done
