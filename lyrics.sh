#!/bin/sh
#
# SPDX-License-Identifier: GPL-3.0-or-later
# myMPD (c) 2018-2022 Juergen Mang <mail@jcgames.de>
# https://github.com/jcorporation/musicdb-scripts
#

REALNAME=$(realpath "$0")
SCRIPT_DIR=$(dirname "$REALNAME")
if [ -d "$SCRIPT_DIR/lyrics" ]
then
    PLUGINS=$(echo "$SCRIPT_DIR"/lyrics/*.py)
elif [ -d "/usr/lib/lyrics" ]
then
    PLUGINS=$(echo /usr/lib/lyrics/*.py)
elif [ -d "/usr/local/lib/lyrics" ]
then
    PLUGINS=$(echo /usr/local/lib/lyrics/*.py)
else
    echo "Lyric plugin folder not found, tried:"
    echo "  - $SCRIPT_DIR/lyrics/"
    echo "  - /usr/lib/lyrics"
    echo "  - /usr/local/lib/lyrics"
    echo ""
    exit 1 
fi

DIRECTORY=$1

print_usage() {
    echo "Usage: $0 <directory|file>"
    echo ""
    echo "This script uses the lyrics plugins from ncmpc:"
    for PLUGIN in $PLUGINS
    do
        echo "  $(basename "$PLUGIN")"
    done
    echo ""
    exit 1
}

[ -z "$DIRECTORY" ] && print_usage

download_lyrics() {
    MEDIA_FILE=$1
    LYRICS_FILE="$(dirname "$FILE")/$(basename "$FILE" .mp3).txt"
    [ -s "$LYRICS_FILE" ] && return
    ARTIST=$(mid3v2 "$MEDIA_FILE" 2>/dev/null | grep "^TPE1=")
    TITLE=$(mid3v2 "$MEDIA_FILE" 2>/dev/null | grep "^TIT2=")

    ARTIST=${ARTIST#*=}
    TITLE=${TITLE#*=}

    echo "Download lyrics for \"$ARTIST - $TITLE\""
    TEXT=""
    for PLUGIN in $PLUGINS
    do
        PLUGIN_NAME=$(basename "$PLUGIN")
        echo "Trying $PLUGIN_NAME"
        if TEXT=$($PLUGIN "$ARTIST" "$TITLE" 2>/dev/null)
        then
            if [ "$TEXT" != "" ]
            then
                {
                    echo "#--"
                    echo "#Lyrics from $PLUGIN_NAME"
                    echo "#--"
                    echo "$TEXT"
                    echo "#--"
                    echo ""
                } >> "$LYRICS_FILE"
            fi
        fi
    done
    [ -s "$LYRICS_FILE" ] || rm -f "$LYRICS_FILE"
}

if [ -f "$DIRECTORY" ]
then
    download_lyrics "$DIRECTORY"
elif [ -d "$DIRECTORY" ]
then
    find "$DIRECTORY" -name \*.mp3 | while read -r FILE
    do
        download_lyrics "$FILE"
    done
fi
