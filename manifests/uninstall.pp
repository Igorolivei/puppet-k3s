# @summary Class responsible for uninstalling k3s
class k3s::uninstall {
  exec { '/usr/local/bin/k3s-uninstall.sh':
    onlyif => '/usr/bin/test -f /usr/local/bin/k3s-uninstall.sh',
  }
}
