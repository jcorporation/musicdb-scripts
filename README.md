# musicdb-scripts

This repository provides bash scripts to download images and lyrics for your music files.

## Albumart download and resize script

A script to maintain albumart. This script downloads albumart from [coverartarchive.org](https://coverartarchive.org/). 

- Works only for ID3v2 tagged MP3 files with the MusicBrainz Album Id
- Optionally: Customize the image sizes and names in the script header
- Run `./albumart.sh download <music directory>` to download the albumart
- Run `./albumart.sh resize <music directory>` to resize the albumart and create thumbnails
- Run `./albumart.sh check <music directory>` to check the albumart sizes
- Run `./albumart.sh missing <music directory>` to find album folders without an image

**Dependencies:** ImageMagick, mid3v2 (mutagen), wget

## Artistart download and resize script

A script to download artistart from [fanart.tv](https://fanart.tv/). 

- Works only for ID3v2 tagged MP3 files with the MusicBrainz Artist Id and TPE1
- Optionally: Customize the image sizes and names in the script header
- Set the fanart.tv API Key: `export API_KEY="<key>"`
- Run `./artistart.sh <media file>` to download the artistart to the `/var/lib/mympd/pics/Artist` folder

**Dependencies:** ImageMagick, mid3v2 (mutagen), wget

## Lyrics download script

A script to download lyrics based on the [https://github.com/MusicPlayerDaemon/ncmpc/tree/master/lyrics](ncmpc plugins).

The script tries all plugins from the lyrics folder and adds all the results to a .txt file. You should afterwards edit this file and select the best result.

```
Usage: lyric.sh <file|directory>

```

- Works only for ID3v2 tagged MP3 files
- If you provide a directory the script searches recursively for MP3 files
- Name of the result file is the name of the MP3 file with .txt extension

**Depenedencies**: python, mid3v2 (mutagen)
