#! /bin/sh

### version.sh --- Generic versioning script for LaTeX packages

## Copyright (C) 2017 Didier Verna

## Author: Didier Verna <didier@didierverna.net>

## This file is part of LtxPkg.

## Permission to use, copy, modify, and distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.

## THIS SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


### Commentary:

# LtxPkg is a generic infrastructure for maintaining LaTeX packages.  This
# script automates the updating of the version number and release date in the
# dtx files.

# The relase date is computed from the current date. The version number is
# either given on the command line, or computed from the NEWS file (with lines
# of the form "* Version x.x" for each version), or left untouched. Once the
# release date and version number are known, this script looks for the
# following lines and updates them in the .dtx files:

# \ProvidesClass{foo}[<releasedate> v<version>
# \ProvidesPackage{foo}[<releasedate> v<version>

# This script also has the capability to commit to git and even tag as a
# release.

## Usage:

# You may call this script directly from the command-line (see the `usage'
# fonction below for command-line arguments). You can also use it as a Git
# post-commit hook (for instance, to bump the release date automatically).


### Code:

prog=`basename $0`

dry_run=no

version=

commit=no
tag=no

date=`date +%Y/%m/%d`

usage ()
{
  cat <<EOF
Usage: $prog [OPTIONS]

  -h, --help:    display this help and exit
  -n, --dry-run: just pretend to run (defaults to no)

  -v  --version[=VERSION]: set new version number to VERSION
			   or use the latest version from the NEWS file

  -c, --commit: commit the change (defaults to no)
  -t, --tag:    tag the repository (defaults to no)
		implies -c unless nothing to commit
EOF
}

while test $# != 0
do
  # Standalone options:
  found=yes
  case $1 in
    -h | --help)    usage && exit 0;;
    -n | --dry-run) dry_run=yes;;
    -c | --commit)  commit=yes;;
    -t | --tag)     commit=yes && tag=yes;;
    *) found=no;;
  esac
  test $found = yes && shift && continue

  # (Optionally) Valued options:
  found=yes
  case $1 in
    --*=*) option=`expr "$1" : '\([^=]*\)='`
	   value=`expr "$1" : '[^=]*=\(.*\)'`
	   shift;;
    -*)    option="$1"
	   shift
	   case $option in
	     -*) value=__none__;;
	     *)  value="$1" && shift;;
	   esac;;
  esac
  case "$option" in
    -v | --version) version="$value";;
    *) found=no;;
  esac
  test $found = yes && continue

  echo "unknown option: $option" && exit 1
done


version_str=
version_tag=
news_version=`grep -m 1 "^*[ \t]*Version" NEWS \
	    | sed 's|\*[ \t]*Version[ \t]*\(.*\)|\1|'`
if test "x$version" = "x"
then
  # not given
  version_str="\3" # this depends on the regexp below
  version_tag="`echo $news_version | tr '-' ' '`"
elif test "x$version" = "x__none__"
then
  # use latest from the NEWS file
  version_str="$news_version"
  version_tag="`echo $news_version | tr '-' ' '`"
else
  version_str="$version"
  version_tag="`echo $version | tr '-' ' '`"
fi


# Hack the dtx file:
if test $dry_run = yes
then
  echo "perl -pi -e \"s|(\\\Provides(Class\|Package)\{[a-z]+\})\[\d{4}/\d{2}/\d{2} v([^ ]+) (.*)|\1\[$date v$version_str \4|\" *.dtx"
else
  perl -pi -e "s|(\\\Provides(Class\|Package)\{[a-z]+\})\[\d{4}/\d{2}/\d{2} v([^ ]+) (.*)|\1\[$date v$version_str \4|" *.dtx
fi

if test "x$commit" = "xyes"; then
  test "x`git status | grep 'nothing to commit'`" = "x" || commit=no
fi

# Commit the change:
if test "x$commit" = "xyes"; then
  if test $dry_run = yes
  then
    echo "git ci -a"
  else
    git ci -a
  fi
fi

# Tag the repository:
if test "x$tag" = "xyes"; then
  if test $dry_run = yes
  then
    echo "git tag -a -m \"Version ${version_tag}, release date $date\" \"version-${version_tag}\""
  else
    git tag -a -m "Version ${version_tag}, release date $date" \
	"version-${version_tag}"
  fi
fi

exit 0
