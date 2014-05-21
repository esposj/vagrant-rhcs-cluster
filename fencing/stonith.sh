#!/bin/sh -x

# Script to stop and start a virtual machine.
# The only required argument is machinename.

eval $(cat -)

# I use Apple Mac OS X, but any OS may be used.
vboxmanage="/Applications/VirtualBox.app/Contents/MacOS/VBoxManage"

usage () {
/bin/echo "Usage: $0 -a NAME [-o ACTION]"
/bin/echo
/bin/echo " -a NAME"
/bin/echo "   The name of the virtual machine to be fenced."
/bin/echo "   In case it contains spaces, use double quotes."
/bin/echo " -o ACTION"
/bin/echo "   What to do; start|stop|reboot(default)."
/bin/echo
exit 1
}

while [ "$#" -gt 0 ] ; do
case "$1" in
  -a)
   if [ "$2" ] ; then
    vm="$2"
    shift ; shift
   else
    /bin/echo "Missing value for $1."
    /bin/echo
    usage
    shift
   fi
  ;;
  -o)
   if [ "$2" ] ; then
    action="$2"
    shift ; shift
   else
    /bin/echo "Missing value for $1."
    /bin/echo
    usage
    shift
   fi
  ;;
  *)
   /bin/echo "Not a know option, $1."
   usage
   shift
  ;;
esac
done

if [ ! "${action}" ] ; then
action=reboot
fi

if [ ! "${vm}" ] ; then
/bin/echo "Error, please specify a name."
usage
fi

check() {
ssh $host "$vboxmanage showvminfo ${vm}" > /dev/null 2>&1
if [ ${?} != 0 ] ; then
  /bin/echo "Error, VM ${vm} not found, choose one of these:"
  ssh $host "$vboxmanage list vms | sed 's/" .*/"/'"
  exit 1
fi
}


stop() {
ssh $host "$vboxmanage controlvm ${vm} poweroff > /dev/null 2>&1"
}

start() {
ssh $host "$vboxmanage startvm ${vm} > /dev/null 2>&1"
}

reboot() {
stop
sleep 3
start
}

case $action in
start)
  check
  start
;;
stop)
  check
  stop
;;
reboot)
  check
  reboot
;;
*)
  /bin/echo "Unknown action: $action"
  /bin/echo
  usage
;;
esac
