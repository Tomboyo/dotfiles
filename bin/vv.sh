#!/bin/bash
# Open nvim, choosing form a list of installed profiles.

declare -a profiles
i=0
for dir in ~/.config/nvim-* ; do
  profiles[i++]=$(basename "$dir")
done

select profile in ${profiles[@]}; do
  NVIM_APPNAME="$profile" nvim $@
  break
done
