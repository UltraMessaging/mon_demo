#!/bin/sh
# tst.sh

source ~/lbm.sh

rm -f *.log

lbmrd lbmrd.xml >lbmrd.log 2>&1 &
LBMRD_PID="$!"
sleep 0.1

lbmmon --transport-opts="config=mon.cfg" >lbmmon.log 2>&1 &
LBMMON_PID="$!"
sleep 0.1

# Give lbmrcv a little loss.
LBTRM_LOSS_RATE=1 lbmrcv -c demo.cfg -E 29west.example.multi.0 2>&1 >lbmrcv.log &
LBMRCV_PID="$!"

# lbmwrc will subscribe to all topics, which will be 29west.example.multi.0 and 29west.example.multi.1
lbmwrcv -c demo.cfg -E -v "^29west\.example\.multi\.[01]$" >lbmwrcv.log 2>&1 &
LBMWRCV_PID="$!"

lbmsrc -c demo.cfg -M 50000 -P 1 29west.example.multi.0 >lbmsrc.log 2>&1 &
LBMSRC_PID="$!"

# lbmmsrc will publish 2 topics: 29west.example.multi.0 and 29west.example.multi.1
lbmmsrc -c demo.cfg -M 50000 -P 1 -S 2 -T 1 >lbmmsrc.log 2>&1 &
LBMMSRC_PID="$!"

wait $LBMRCV_PID $LBMWRCV_PID $LBMSRC_PID $LBMMSRC_PID

kill $LBMMON_PID $LBMRD_PID
