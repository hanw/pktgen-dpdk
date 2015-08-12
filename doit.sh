#!/bin/bash

# Normal setup
#   different cores for each port.

name=`uname -n`

# Use 'sudo -E ./setup.sh' to include environment variables

if [ -z ${RTE_SDK} ] ; then
    echo "*** RTE_SDK is not set, did you forget to do 'sudo -E ./setup.sh'"
	export RTE_SDK=/home/hwang/dpdk
	export RTE_TARGET=x86_64-native-linuxapp-gcc
fi
sdk=${RTE_SDK}

if [ -z ${RTE_TARGET} ]; then
    echo "*** RTE_TARGET is not set, did you forget to do 'sudo -E ./setup.sh'"
    target=x86_64-native-linuxapp-gcc
else
    target=${RTE_TARGET}
fi


if [ $name == "sonic1" ]; then
#./app/app/${target}/pktgen -c 1fff0 -n 3 --proc-type auto --log-level=0 --socket-mem 512,512 --file-prefix pg -b 06:00.0 -b 06:00.1 -b 08:00.0 -b 08:00.1 -b 09:00.0 -b 09:00.1 -b 83:00.1 -- -T -P -m "[5:7].0, [6:8].1, [9:11].2, [10:12].3" -f themes/black-yellow.theme
DEBUG=1
CONNECTALDIR=/home/hwang/sonic-lite
PROJ=sonic
JNI_PATH=${CONNECTALDIR}/${PROJ}/bluesim/jni
PKTGEN_PATH=/home/hwang/pktgen-dpdk/app/app/${target}/pktgen
if [ $DEBUG -eq 1 ]; then
GDB="gdb --args"
else
GDB="LD_PRELOAD=libSegFault.so SEGFAULT_USE_ALTSTACK=1 SEGFAULT_OUTPUT_NAME=bsimexe-segv-output.txt"
fi
RUN_ARGS="-c f -n 2  --vdev eth_sonic0 --vdev eth_sonic1 --proc-type auto --socket-mem 512,512 --file-prefix pg -- -T -P -m [1:2].0,[3:4].1"
sudo LD_LIBRARY_PATH=$JNI_PATH $GDB $PKTGEN_PATH $RUN_ARGS;
fi

