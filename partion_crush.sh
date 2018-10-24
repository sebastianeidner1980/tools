#!/bin/bash

#abort on error
set -e

function usage
{
    echo "usage: crush_partition [-d device || -h]"
    echo "   ";
    echo "  -d | --device : only this device for example sda will not crushed";
    echo "  -h | --help   : This message";
}

function parse_args
{
  # positional args
  args=()

  # named args
  while [ "$1" != "" ]; do
      case "$1" in
          -d | --device )              devices="$2";             shift;;
          -h | --help )                usage;                   exit;; # quit and show usage
          * )                          args+=("$1")             # if no match, add it to the positional args
      esac
      shift # move to next kv pair
  done

  # validate required args
  if [[ -z "${devices}" ]]; then
      echo "All partition will be crushed"
  else
      echo "All partitions excecpt $devices will be crushed"
  fi
}


function crush
{
  parse_args "$@"

  for dev in $(lsblk | grep -o "^sd[^ ]*");
  do
     if [[ $dev != $devices ]]
      then
       part_number=$(grep -c "$dev[0-9]" /proc/partitions)
       for((j=1; j<=$part_number; j++))
        do
                parted /dev/$dev rm $j
        done
    fi
done;
}

crush "$@";
