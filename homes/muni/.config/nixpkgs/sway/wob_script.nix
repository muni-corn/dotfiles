{ backgroundColor, borderColor, barColor }:

''
#! /usr/bin/env fish

mkfifo $SWAYSOCK.wob

tail -f $SWAYSOCK.wob | wob -a bottom -H 24 -W 512 -M 256 -p 4 -o 0 -b 6 --border-color '${borderColor}' --bar-color '${barColor}' --background-color '${backgroundColor}'
''
