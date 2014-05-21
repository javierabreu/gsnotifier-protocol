#!/bin/bash
# requires perl, wget, notify-send, sed
URI="$1";

PROTOCOL="gsnotifier";
LOCALALBUMARTFILE="/tmp/gsnotifier_albumart_`date +%s`";
DEFAULTICON="/home/its32ja1/Pictures/Logos/GrooveShark.png";
echo "PROT: $PROTOCOL";
if [ -z $URI ] # URI is setted (longer than 0 chars)
then
	FILTEREDURI="no_description";
else
	#ESCAPED_BASE=$(echo $BASEURL | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g');
	FILTEREDURI=`echo $URI | sed -r "s/^$PROTOCOL:(\/\/)?//"`
fi
arrPARAMS=(${FILTEREDURI//\// });
if [ -z ${arrPARAMS[1]} ] # if arrPARAMS[1] isn't setted, we have no ALBUMARTURI, so let's use DEFAULTICON (longer than 0 chars)
then
	ICON=$DEFAULTICON;
	TEXTPARAMINDEX=0;
	echo "UNSETTED";
else
	ALBUMARTURI=`echo "${arrPARAMS[0]}" | perl -MURI::Escape -lne 'print uri_unescape($_)'`; #UNESCAPE URL
	echo "${arrPARAMS[0]}";
	echo "$ALBUMARTURI";
	rm $LOCALALBUMARTFILE;
	ICON="`wget --quiet --timeout=5 --max-redirect=0 -O $LOCALALBUMARTFILE $ALBUMARTURI && echo $LOCALALBUMARTFILE || echo "$DEFAULTICON"`"
	TEXTPARAMINDEX=1;
	echo "SETTED";
fi
TEXT=`echo "${arrPARAMS[$TEXTPARAMINDEX]}" | perl -MURI::Escape -lne 'print uri_unescape($_)'`; #UNESCAPE URL
echo "TEXT: $TEXT";
echo "ICON: $ICON";

echo "Notifying: Now playing: $TEXT"
notify-send --urgency=low --expire-time=1250 --hint=int:transient:1 --icon="$ICON" "Now playing" "$TEXT"
