#!/bin/bash
# Simple script to discover the maximum path MTU (PMTU) to a target

argv=("$@")
script_name=$(basename $0)
default_min_mtu=1200
default_max_mtu=1514
default_die_after=3
default_interval=0.05

trap 'kill $$' SIGINT

if [ $(uname) == "Darwin" ]
then
  pingcmd="ping -D -t 1 -c 1"
else
  pingcmd="ping -Mdo -w 1 -c 1"
fi

function main() {
  failures=0
  last_good_mtu=0
  for i in `seq $min_mtu $max_mtu`
  do $pingcmd -s $i $target -q 2>&1>/dev/null
    if [ $? -eq 0 ]; then
      last_good_mtu=$i
      failures=0
      echo -n "!"
    else
      let "failures=failures+1"
      echo -n "."
    fi
    if [ $failures -eq $die_after ]
    then
      echo "Stopping."
      echo "No response after $last_good_mtu ($(($last_good_mtu+20+8)) with headers)"
      kill $$
    fi
    sleep $default_interval
  done
}

if [[ $# -ge 1 ]]
then
  target=${argv[0]}
  min_mtu=${argv[1]-$default_min_mtu}
  max_mtu=${argv[2]-$default_max_mtu}
  die_after=${argv[3]-$default_die_after}
  echo $target $min_mtu $max_mtu
  main
else
  echo "Usage: ${script_name} target_ip {min_mtu (${default_min_mtu})} {max_mtu (${default_max_mtu})} {die_after(${default_die_after})}"
fi
argv=(“$@”)
