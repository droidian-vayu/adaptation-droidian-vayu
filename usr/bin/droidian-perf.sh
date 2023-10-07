#!/bin/bash

CORE_FIRST=$(awk '$1 == "processor" {print $3; exit}' /proc/cpuinfo)
CORE_LAST=$(awk '$1 == "processor" {print $3}' /proc/cpuinfo | tail -1)

for ((i=$CORE_FIRST; i<=$CORE_LAST; i++))
do
   MAXFREQ=$(cat /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_available_frequencies | awk '{print $NF}')
   if [ -f "/var/lib/batman/default_cpu_governor" ]; then
      GOVERNOR=$(</var/lib/batman/default_cpu_governor)
   else
      GOVERNOR=$(</sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor)
   fi

   if [ -f "/sys/devices/system/cpu/cpu${i}/sched_load_boost" ]; then
       echo -6 > /sys/devices/system/cpu/cpu${i}/sched_load_boost
       echo -n "/sys/devices/system/cpu/cpu${i}/sched_load_boost "
       cat /sys/devices/system/cpu/cpu${i}/sched_load_boost
   fi

   if [ -d "/sys/devices/system/cpu/cpu${i}/cpufreq/$GOVERNOR" ]; then
      if [ -f "/sys/devices/system/cpu/cpu${i}/cpufreq/${GOVERNOR}/hispeed_freq" ]; then
         echo "$MAXFREQ" > /sys/devices/system/cpu/cpu${i}/cpufreq/${GOVERNOR}/hispeed_freq
         echo -n "/sys/devices/system/cpu/cpu${i}/cpufreq/${GOVERNOR}/hispeed_freq "
         echo "$MAXFREQ"
      fi
   fi
done

mkdir -p /sys/fs/cgroup/schedtune

mount -t cgroup -o schedtune stune /sys/fs/cgroup/schedtune

[ -f /sys/fs/cgroup/schedtune/schedtune.boost ] && echo 20 > /sys/fs/cgroup/schedtune/schedtune.boost
[ -f /sys/fs/cgroup/schedtune/schedtune.prefer_idle ] && echo 1 > /sys/fs/cgroup/schedtune/schedtune.prefer_idle
