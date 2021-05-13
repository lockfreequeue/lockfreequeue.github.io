# ipmctl Functionality includes:
Discover Intel Optane persistent memory modules on the platform
Provision the platform memory configuration
View and update module firmware
Configure data-at-rest security
Monitor module health
Track performance of modules
Debug and troubleshoot modules
## module discovery

    show basic info;
    $sudo ipmctl show -topology

    $ ipmctl show -d DimmHandle,DimmUID -dimm 8089-a2-1748-00000001
    $ ipmctl show -d DimmHandle,DimmUID -dimm 0x0001
    $ ipmctl show -d DimmHandle,DimmUID -dimm 1

DimmHandle:
The DimmHandle is equivalent to the DimmUID and is formatted as 0xABCD, where A, B, C, and D are defined as follows:
    A = Socket
    B = Memory Controller
    C = Channel
    D = Slot

ipmctl show -system -capabilities : Show System Capabilities
ipmctl show -socket  
ipmctl show -memoryresources
ipmctl show -dimm

## provisionning
concepts:
   Goals specify which operating mode the modules are to be used in.
   A region is a grouping of one or more persistent memory modules.  Regions can be created as either non-interleaved, meaning one region per persistent memory module, or interleaved, which creates one large region over all modules in a CPU socket.
   namespace: Regions can be divided up into one or more namespaces. A namespace defines a contiguously addressed range of non-volatile memory conceptually similar to a disk partition, or an NVM Express namespace.
   A label is similar to a partition table. 
   Label Storage Area (LSA): Namespaces are defined by Labels which are stored in the Label Storage Area(s).

## regions
ndctl list --regions

#namespace
sudo ndctl create-namespace -m fsdax -s 252G -r region1

# ref
https://docs.pmem.io/ipmctl-user-guide/
