# @summary Class responsible for uninstalling k3s
class k3s::uninstall {
  case $k3s::installation_mode {
    'script': {
      exec { '/usr/local/bin/k3s-uninstall.sh':
        onlyif => '/usr/bin/test -f /usr/local/bin/k3s-uninstall.sh',
      }
    }

    'binary': {
      file { $k3s::binary_path:
        ensure => absent,
      }
    }

    default: {
      notify { 'No valid installation mode provided.': }
    }
  }
}
