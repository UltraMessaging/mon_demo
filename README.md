# mon_demo
A set of Ultra Messaging configuration files and a test script
to demonstrate setting up UM automatic monitoring.

# Table of contents

<sup>(table of contents from https://luciopaiva.com/markdown-toc/)</sup>

## COPYRIGHT AND LICENSE

All of the documentation and software included in this and any
other Informatica Ultra Messaging GitHub repository
Copyright (C) Informatica. All rights reserved.

Permission is granted to licensees to use
or alter this software for any purpose, including commercial applications,
according to the terms laid out in the Software License Agreement.

This source code example is provided by Informatica for educational
and evaluation purposes only.

THE SOFTWARE IS PROVIDED "AS IS" AND INFORMATICA DISCLAIMS ALL WARRANTIES
EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION, ANY IMPLIED WARRANTIES OF
NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR
PURPOSE.  INFORMATICA DOES NOT WARRANT THAT USE OF THE SOFTWARE WILL BE
UNINTERRUPTED OR ERROR-FREE.  INFORMATICA SHALL NOT, UNDER ANY CIRCUMSTANCES,
BE LIABLE TO LICENSEE FOR LOST PROFITS, CONSEQUENTIAL, INCIDENTAL, SPECIAL OR
INDIRECT DAMAGES ARISING OUT OF OR RELATED TO THIS AGREEMENT OR THE
TRANSACTIONS CONTEMPLATED HEREUNDER, EVEN IF INFORMATICA HAS BEEN APPRISED OF
THE LIKELIHOOD OF SUCH DAMAGES.

## REPOSITORY

See https://github.com/UltraMessaging/mon_demo for code and documentation.

## INTRODUCTION

Informatica recommends that Ultra Messaging users enable the
automatic monitoring feature in their UM-based applications and most
UM daemons (Store, DRO,etc).

Starting in [UM version 6.10](https://ultramessaging.github.io/currdoc/doc/ChangeLog/html1/index.html#streamingenhancementsfor6_10), 
properly-configured automatic monitoring does not significantly affect
the latency or throughput for application messages.
(Prior to UM 6.10, there was a contention point that caused the occasional
latency outlier. This was fixed in 6.10.)

## Configuration Goals

* Route monitoring packets to a different network interface than
the latency-sensitive application data.
For example, use the administrative network.
This eliminates contention for network resources.
* Use the TCP protocol, which minimizes the demands on the network.
* Use unicast UDP with the "lbmrd" for topic resolution.
This avoids multicast on your administrative network.
It also allows applications running old versions of UM to be
monitored.
* Disable the monitoring context's MIM and request ports.
This minimizes the use of host resources.
* Use the "lbmmon.c" example application.
This can be replaced by the "MCS" process in the future,
but for demonstration purposes, "lbmmon" is easier.

## Run the demo

The "tst.sh" shell script runs a set of applications and the
"lbmmon" program to collect the statistics.
See the file "lbmmon.log" for the output of my example run of the
script.

Note that the script intentionally introduces a small amount of loss
on one of the programs.
This is to demonstrate the presence of loss/NAK-related statistics.
