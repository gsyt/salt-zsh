salt-zsh
========
Salt formula to set up and configure [Zsh](http://www.zsh.org/)

Parameters
----------
Please refer to example.pillar for a list of available pillar configuration options

Requirements
------------
None

Usage
-----
- Apply state 'zsh.intsall' to install zsh to target minions
- State 'zsh' is provided as an alia for vim.install

Notes
-----
No purge state is provided as this may leave users shell-orphaned under certain scenarios

Compatibility
-------------
Ubuntu 14.10 and CentOS 6.x
