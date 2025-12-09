#!/bin/sh

for dir in "$@"; do
  if [ -d $dir ]; then
    for file in $(find $1 -iname '*.h' -or -iname '*.cpp'); do
      clang-format -i $file
    done
  fi
done
