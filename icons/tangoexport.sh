#!/bin/bash
#
# Usage: tangoexport.sh
#
# Should be run in the directory containing the SVG files.
# Assumes it runs on the directory named according to freedesktop.org's
# naming conventions
#
# BUGS:
# - has errors in output
# - is hardcoded for current Kitanda use
#

inkscape=`which inkscape`

if [ "x${inkscape}" = "x" ]; then
    echo “Cannot find Inkscape on path. Exiting...”
    exit 1
fi

iconpath="$HOME/Development/kitanda/kitanda/artwork/icons"

mkdir -p $iconpath/16x16/apps
mkdir -p $iconpath/16x16/actions
mkdir -p $iconpath/22x22/apps
mkdir -p $iconpath/22x22/actions
mkdir -p $iconpath/32x32/apps
mkdir -p $iconpath/32x32/actions
mkdir -p $iconpath/48x48/apps
mkdir -p $iconpath/48x48/actions

for CURRENT_FILE in *.svg
do
    inputbase=`basename $CURRENT_FILE .svg`
    oldifs=$IFS
    IFS='_'
    set -- $inputbase

    CWD=`pwd`
    section=`basename ${CWD}`

    IFS=$oldifs
    PNG_NAME=$1

    for size in "16x16/0:0:48:48" "22x22/0:0:48:48" "32x32/0:0:48:48" "48x48/0:0:48:48"
    do
        oldifs=$IFS
        IFS="/"
        set -- $size
        iconsize=$1
        coords=$2
        IFS=$oldifs
        width=`echo $iconsize | sed -e 's/x.*//g'`
        height=`echo $iconsize | sed -e 's/.*x//g'`
        command="${inkscape} -f $CURRENT_FILE -z -e $iconpath/${iconsize}/${section}/${PNG_NAME}.png --export-area-page --export-width=$width --export-height=$height"
        echo "DEBUG command --> " $command
        `${command}`
        echo
    done
done