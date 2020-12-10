# k3s

Welcome to k3s module. This module installs the Rancher's lightweight
Kubernetes, k3s (see more on https://k3s.io/).

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with k3s](#setup)
    * [Beginning with k3s](#beginning-with-k3s)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Development - Guide for contributing to the module](#development)

## Description

This module installs the open source Rancher's lightweight Kubernetes, k3s.

Using this module, you can easily automate k3s installation in many machines,
like in a School Lab or in a Raspberry Pi cluster.

## Setup

### Beginning with k3s

Install this module using Puppet: `puppet module install igorolivei/k3s`

Or via Puppetfile: `mod 'igorolivei-k3s', '1.0.0'`

## Usage

- Quick run: `puppet apply -e "include k3s"`

- Installing using the script installation mode:

```puppet
class { 'k3s':
  installation_mode => 'script',
}
```

- Installing using the binary installation mode:

```puppet
class { 'k3s':
  installation_mode => 'binary',
}
```

- Ensuring that it is uninstalled:

```puppet
class { 'k3s':
  ensure            => 'absent',
  installation_mode => 'binary',
}
```

## Development

### Contributing

- Create a topic branch from where you want to base your work. This is usually the master branch.
- Push your changes to a topic branch in your fork of the repository.
- Add yourself as a contributor in the Contributors sections of this file.
- Make sure your commits messages are describing what has changed.
- Make sure you have tested your changes and nothing breaks.
- Validate your module using `pdk validate`.
- Submit a pull request to this repository.

## Release Notes/Contributors/Etc.

- Author: Igor Oliveira (igor.bezerra96@gmail.com)
- Contributor: Pete Fritchman (@fetep)
