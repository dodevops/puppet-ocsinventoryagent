# dodevops/ocsinventoryagent

[![Build status](https://img.shields.io/travis/dodevops/puppet-ocsinventoryagent.svg)](https://travis-ci.org/dodevops/puppet-ocsinventoryagent)

#### Table of Contents

1. [Description](#description)
3. [Usage - Configuration options and additional functionality](#usage)

## Description

This puppet module installs and configures the linux agent for [OCS-Inventory](https://ocsinventory-ng.org/?lang=en).

## Usage

Use the class ocsinventoryagent to install and configure the agent. See the reference section for details.

```
class {
  'ocsinventoryagent':
    server => 'https://ocs.company.com',
}
```
