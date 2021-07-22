# dodevops/ocsinventoryagent

[![Build status](https://img.shields.io/travis/dodevops/puppet-ocsinventoryagent.svg)](https://travis-ci.org/dodevops/puppet-ocsinventoryagent)

#### Table of Contents

1. [Description](#description)
3. [Usage - Configuration options and additional functionality](#usage)

## Description

This puppet module installs and configures the linux agent for [OCS-Inventory](https://ocsinventory-ng.org/?lang=en).

## Requirements

### Package repo for non Debian based operating systems

You need to care for the ocsinventory-agent package repository by yourself on non Debian based operating systems.

On Debian based operating systems, the pacakge is part of the repositories.

### SLES requirements

On SLES (only SLES 15 tested so far) the "Desktop Applications" and the "Development Tools" software modules need to be
activated in order for dependencies to be available. Some of the dependencies are not available in the the software
pools for SLES and need to be provided separatly. Recommended is the opensuse software portal 
https://software.opensuse.org/. Recommended is the "devel:languages:perl" project there, where most of the packages are 
available. Every infrastructure is different, so please take care of providing these pacakges on your own. This module
only has package install definitions for those packages.

The affected packages in detail are:
* perl-Data-UUID
* perl-Proc-Daemon
* perl-Proc-ProcessTable
* perl-Proc-Simple

### Sysconfig file

The packages for non Debian based operating systems are very fragmented. For RedHat/Centos there are packages in EPEL 
but also on the repo of the OCS inventory project itself, both are structured very different. Also for SLES you can find
many different packages in the OpenSUSE build service.

Nearly all (exception is f.e. the EPEL package) of those packages have in common, that you have to configure a sysconfig
file in order for the agent (or to be specific: its cronjob) to do something. Some of them provide templates for it, some
not. And the config flags in those differ. So please take care about the sysconfig file on your own, if required.

### CA

If your OCS server has the complete chain (root CA, intermediate, certificate), your agent should work without a CA set.
However if you don't configure the root CA on your OCS server, you need to provide the root CA on the agent. If your 
server uses a certificate signed by a usual CA, the CA bundle of the specific OS has proven to work fine. You can spot
that something is wrong with your CA setup if your agent looks for a CAcert.pem file in its /var directory and cant find it.

## Usage

Use the class ocsinventoryagent to install and configure the agent. See the reference section for details.

```
class {
  'ocsinventoryagent':
    server => 'https://ocs.company.com',
}
```
