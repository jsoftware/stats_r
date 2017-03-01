stats/r addon

The stats/r addon has core utilities for interfacing with R.

There are three such interfaces. For most purposes, the
rserver interface is recommended.

  rserver  - calls R shared library
  rserve   - uses the Rserve system for communicating via sockets
  rdcmd    - calls R in batch

The distributed scripts are:

  rserver.ijs  - rserver utilities
  rserve.ijs   - rserve utilities
  rdsock.ijs   - rserve socket handling
  rbase.ijs    - rserve base utilities

  rdcmd.ijs    - batch script

For more information, see http://code.jsoftware.com/wiki/Interfaces/R



