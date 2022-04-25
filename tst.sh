#!/bin/sh
# tst.sh

source ../lbm.sh

lbmrd lbmrd.xml >lbmrd.log 2>&1 &
LBMRD_PID="$!"
sleep 0.1

cp mon.template mon.cfg
ifconfig | sed -n 's/^.*\(10\.29\.3\.[0-9]*\)[^0-9].*/context resolver_unicast_daemon \1:12001/p' >>mon.cfg

lbmmon --transport-opts="config=mon.cfg" >lbmmon.log 2>&1 &
LBMMON_PID="$!"
sleep 0.1

# Give this one a little loss.
LBTRM_LOSS_RATE=1 lbmmrcv -c demo.cfg -E -C 1 -R 1 >lbmmrcv1.log 2>&1 &
LBMMRCV1_PID="$!"

lbmwrcv -c demo.cfg -E ".*" >lbmwrcv.log 2>&1 &
LBMWRCV_PID="$!"

lbmmsrc -c demo.cfg -M 50000 -P 1 -S 1 -T 1 >lbmmsrc1.log 2>&1 &
LBMMSRC1_PID="$!"

lbmmsrc -c demo.cfg -M 50000 -P 1 -S 2 -T 1 >lbmmsrc2.log 2>&1 &
LBMMSRC2_PID="$!"

wait $LBMMRCV1_PID $LBMWRCV_PID $LBMMSRC1_PID $LBMMSRC2_PID

kill $LBMMON_PID $LBMRD_PID
