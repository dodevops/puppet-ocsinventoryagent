# dodevops/ocsinventoryagent

[![Build status](https://img.shields.io/travis/dodevops/puppet-ocsinventoryagent.svg)](https://travis-ci.org/dodevops/puppet-ocsinventoryagent)

#### Table of Contents

1. [Description](#description)
3. [Usage - Configuration options and additional functionality](#usage)

## Description

This puppet module installs and configures the linux agent for [OCS-Inventory](https://ocsinventory-ng.org/?lang=en).

## Requirements

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

## Usage

Use the class ocsinventoryagent to install and configure the agent. See the reference section for details.

```
class {
  'ocsinventoryagent':
    server => 'https://ocs.company.com',
}
```
