#!/bin/bash
#
# SPDX-License-Identifier: GPL-3.0-or-later
# myMPD (c) 2018-2022 Juergen Mang <mail@jcgames.de>
# https://github.com/jcorporation/musicdb-scripts
#

REALPATH=$(realpath "$0")
PLUGINPATH=$(dirname "$REALPATH")

TMPDIR=$(mktemp -d)
cd "$TMPDIR" || exit 1
if git clone --depth=1 git@github.com:MusicPlayerDaemon/ncmpc.git
then
    rm "$PLUGINPATH/"*.py
    cp -av "$TMPDIR/ncmpc/lyrics/"*.py "$PLUGINPATH"
fi

rm -rf "$TMPDIR"
