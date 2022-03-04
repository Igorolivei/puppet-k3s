# @summary Class responsible for installing k3s
class k3s::install {
  $script_path = '/usr/local/bin/k3s-install.sh'

  archive { $script_path:
    ensure           => present,
    filename         => $script_path,
    source           => 'https://get.k3s.io',
    creates          => $script_path,
    download_options => ['-s'],
    cleanup          => false,
  }

  file { $script_path:
    ensure  => file,
    mode    => '0755',
    require => Archive[$script_path],
  }

  $token = pick($k3s::token, fqdn_rand_string(32))

  file { ['/etc/rancher', '/etc/rancher/k3s']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  if $k3s::version == 'stable' or $k3s::version == 'latest' {
    $version = { install-k3s-channel => $k3s::version }
  } else {
    $version = { install-k3s-version => $k3s::version }
  }
  $_config = $k3s::operation_mode ? {
    'agent' => $k3s::agent_config,
    default => $k3s::server_config,
  }
  file { '/etc/rancher/k3s/config.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => to_yaml(merge({
      token  => $token,
      server => $k3s::server,
    }, $_config, $version)),
  }

  $args = $k3s::operation_mode ? {
    'server' => "--cluster-init",
    default  => "",
  }
  $command = "${script_path} ${k3s::operation_mode} ${args}"

  exec { $command:
    require     => File[$script_path],
    subscribe   => [Archive[$script_path], File['/etc/rancher/k3s/config.yaml']],
    refreshonly => true,
  }
}
