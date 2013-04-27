Dvash Defense
=============

Part modular honeypot, part defense system, multithreaded and ready for IPv6.  Opens up ports and simulates services in order to look like an attractive target.  Hosts that try to connect to the fake services are considered attackers and blocked from all access.  Heavily inspired by <a href="https://github.com/trustedsec/artillery/">The Artillery Project</a> by Dave Kennedy (ReL1K) with a passion for ruby and a thirst for knowledge.

What Does Dvash Do?
-------------------

It's very alpha right now but here's where we are:
>1. Dvash is ready for Linux, Mac OS X and Windows 7 (or higher). It must be run with elevated privileges.
>2. According to the paths you set in dvash.conf file it will look for iptables (Linux), ipfw (Mac OS X), and on Windows it will use routes to blackhole a client IP address.
>3. On Linux if iptables is found successfully Dvash will prepare the tables for blocking addresses by first creating a new chain named DVASH then setting a reference to it in the INPUT chain.
>4. Once ready it will begin to load all the modules configured in dvash.conf by created a new thread for each module.
>5. Finally, once all the modules are successfully loaded the threads will begin to work.

Honeyport Modules
-----------------

Dvash is designed to be modular so adding a new honeyport service to simulate is a templated code base.  Each built-in module follows a few steps:
>1. When a honeyport module thread starts it sits and listens for a connection.
>2. The thread forks the process when a client connects and accepts the connection.
>3. The forked process then sends the client connection junk data.
>4. The peer address is validated since anything in a payload can be manipulated.
>5. A valid IPv4 or IPv6 address is then blocked in iptables/ip6tables accordingly.
>6. Finally, the connection is closed and the forked process killed.

How to run Dvash
----------------

To install: `gem install dvash`

To run: `sudo dvash --help`

Configuration file: Copy the base configuration file from this github repository in etc/dvash-baseline.conf and set values.
