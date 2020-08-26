# Reference

## Public classes

### `k3s`

Interface class to manage installation or uninstall.

#### Parameters

##### `ensure`

Whether the k3s must be installed or not. Valid options: 'present' or 'absent'.

Default: 'present'.

##### `installation_mode`

The k3s installation method. Valid options: 'script' or 'binary'.

The binary method only installs k3s.

Default: 'script'.

##### `binary_path`

Parameter responsible to define the installation path of the binary.
Valid options: 'string'.

Default: '/usr/bin/k3s'.

##### `binary_version`

Binary version to be installed. Valid options: 'string' in the format
'v0.0.0'.

Default: 'v1.18.8'.

## Private classes

### `k3s::install`

Class responsible to install k3s.

### `k3s::uninstall`

Class responsible to uninstall k3s.
