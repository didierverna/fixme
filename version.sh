#! /bin/sh

dtx=fixme

prog=`basename $0`

dry_run=no

version=
tr_version=
commit=no
tag=no

date=`date +%Y/%m/%d`

usage ()
{
    echo "Usage: $1 [OPTIONS]"
    echo""
    echo "  -h, --help:                    display this help"
    echo "  -n, --dry-run:                 just pretend to run"
    echo "  -v VERSION, --version=VERSION: set new version number to next arg"
    echo "  -c, --commit:                  commit the change"
    echo "  -t, --tag:                     tag the repository (implies -c)"
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
      *) found=no
  esac
  test $found = yes && shift && continue

  # Valued options:
  if expr "$1" : '.*=.*' > /dev/null
      then
      # The --option=value form
      option=`expr "$1" : '\([^=]*\)='`
      value=`expr "$1" : '[^=]*=\(.*\)'`
  else
      # The --option <value> form
      option="$1"
      shift
      value="$1"
  fi
  shift
  case "$option" in
      -v | --version) version="$value";;
  esac
done

# If no new version is given, use the current one:
if test "x$version" = "x"
    then
    version=`grep 'VERSION.*:=.*' Makefile.inc`
    version=`expr "$version" : 'VERSION[ \t]*:=[ \t]*\(.*\)'`
fi
tr_version="`echo $version | tr '-' ' '`"


# hack the Makefile:
if test $dry_run = yes
    then
    echo "perl -pi -e \"s/^(VERSION[ \t]*:=).*/\1 $version/\" Makefile.inc"
else
    perl -pi -e "s/^(VERSION[ \t]*:=).*/\1 $version/" Makefile.inc
fi

# hack the dtx file:
if test $dry_run = yes
    then
    echo "perl -pi -e \"s/(\\\newcommand\{\\\version\}).*/\1\{$version\}/\" $dtx.dtx"
    echo "perl -pi -e \"s|(\\\newcommand\{\\\releasedate\}).*|\1\{$date\}|\" $dtx.dtx"
    echo "perl -pi -e \"s|(\\\ProvidesPackage\{$dtx\}).*|\1\[$date v$version|\" $dtx.dtx"
else
    perl -pi -e "s/(\\\newcommand\{\\\version\}).*/\1\{$version\}/"    $dtx.dtx
    perl -pi -e "s|(\\\newcommand\{\\\releasedate\}).*|\1\{$date\}|"   $dtx.dtx
    perl -pi -e "s|(\\\ProvidesPackage\{$dtx\}).*|\1\[$date v$version|" $dtx.dtx
fi

# commit the change:
if test "x$commit" = "xyes"; then
    if test $dry_run = yes
	then
	echo "darcs record"
    else
	darcs record
    fi
fi

# tag the repository:
if test "x$tag" = "xyes"; then
    if test $dry_run = yes
	then
	echo "darcs tag --checkpoint \"version $tr_version\""
    else
	darcs tag --checkpoint "version $tr_version"
    fi
fi

exit 0
