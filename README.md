dvash [![Gem Version](https://badge.fury.io/rb/dvash.png)](http://badge.fury.io/rb/dvash)

Dvash Defense
=============

Part modular honeypot, part defense system, multithreaded and ready for IPv6.  Opens up ports and simulates services in order to look like an attractive target.  Hosts that try to connect to the fake services are considered attackers and blocked from all access.  Heavily inspired by <a href="https://github.com/trustedsec/artillery/">The Artillery Project</a> by Dave Kennedy (ReL1K) with a passion for ruby and a thirst for knowledge.

How Does Dvash Work?
--------------------

It's very alpha right now but here's where we are:
>1. Dvash is ready for Linux, Mac OS X and Windows 7 (or higher). It must be run with elevated privileges.
>2. Set parameters in the default configuration file according to your system and honeyports you want to use.
>3. Run dvash and watch it block hosts that attempt to connect to honeyports.

What are Honeyports?
--------------------

Dvash is a defensive honeypot, each service that is emulated is called a honeyport as each can be designed to have it's own behaviors.  Dvash is designed to be modular so adding a new honeyport service to emulate is a templated code base.  Each built-in honeyport follows a few steps:
>1. When a honeyport thread starts it sits and listens for a connection.
>2. The thread forks the process when a client connects and accepts the connection.
>3. The forked process then sends the client connection junk data.
>4. The peer address is validated since anything in a packet can be manipulated.
>5. A valid IPv4 or IPv6 address is then blocked.
 * Linux - blocked using IPTables/IP6Tables.
 * Mac OS X - blocked using ipfw.
 * Windows - blocked by blackhole routing.
>6. Finally, the connection is closed and the forked process killed.

How to configure Dvash
----------------------

The default Dvash configuration file can be found <a href="https://github.com/codemunchies/dvash/blob/master/etc/dvash-baseline.conf">here</a>.  Copy this file to your system and set the parameters within it.  Dvash will look for /etc/dvash.conf by default for the configuration file or you can manually point to any copy using the `--config-file` option in a terminal.

How to get Dvash
----------------

To install: `gem install dvash`

To run: `sudo dvash --help`
