Dvash Defense
=============

Part modular honeypot, part defense system, multithreaded and ready for IPv6.  Opens up ports and simulates services in order to look like an attractive target.  Hosts that try to connect to the fake services are considered attackers and blocked from all access.  Heavily inspired by <a href="https://github.com/trustedsec/artillery/">The Artillery Project</a> by Dave Kennedy (ReL1K) with a passion for ruby and a thirst for knowledge.

What Does Dvash Do?
-------------------

It's very alpha right now but here's where we are:
>1. Dvash is only ready for linux and it must be run as root so it makes those checks first.
>2. It then looks for iptables according to the paths you set in dvash.conf file.
>3. If iptables is found successfully Dvash will prepare the tables for blocking addresses by first creating a new chain named DVASH then setting a reference to it in the INPUT chain.
>4. Once the iptables are ready it will begin to load all the modules configured in dvash.conf by created a new thread for each module.
>5. Finally, once all the modules are successfully loaded the threads will begin to work.

Modules
-------

Dvash is designed to be modular so adding a new service to simulate is an easy plugin.  Each built-in module follows a few steps:
>1. Once a module starts is sits and listens for a connection.
>2. The thread forks the process and accepts the connection.
>3. The forked process then sends the client connection junk data.
>4. The peer address is validated since anything in a payload can be manipulated.
>5. A valid IPv4 or IPv6 address is then blocked in iptables/ip6tables accordingly.
>6. Finally, the connection is closed.

How to run Dvash
----------------

To install: `gem install dvash`

To run: `sudo dvash --help`
