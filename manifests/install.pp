# @summary Class responsible for installing k3s
class k3s::install {
  $script_path = '/usr/local/bin/k3s-install.sh'
  $k3s_config = '/etc/rancher/k3s/config.yaml'
  $k3s_version = '/etc/rancher/k3s/version.env'

  File {
    owner => 'root',
    group => 'root',
  }

  archive { $script_path:
    ensure           => present,
    filename         => $script_path,
    source           => 'https://get.k3s.io',
    creates          => $script_path,
    download_options => ['-s'],
    cleanup          => false,
  } -> file { $script_path:
    ensure => file,
    mode   => '0755',
  }

  $token = pick($k3s::token, fqdn_rand_string(32))

  file { ['/etc/rancher', '/etc/rancher/k3s']:
    ensure => directory,
    mode   => '0755',
  }
  $_config = $k3s::operation_mode ? {
    'agent' => $k3s::agent_config,
    default => $k3s::server_config,
  }
  file { $k3s_config:
    ensure  => file,
    mode    => '0600',
    content => to_yaml(merge({
      token  => $token,
      server => $k3s::server,
    }, $_config)),
  }

  if $k3s::version == 'stable' or $k3s::version == 'latest' {
    $version_env = "INSTALL_K3S_CHANNEL=${k3s::version}"
  } else {
    $version_env = "INSTALL_K3S_VERSION=${k3s::version}"
  }
  # This is a hack to have a file that changes to trigger a re-execution of the exec of the command below
  file { $k3s_version:
    ensure  => file,
    mode    => '0644',
    content => $version_env,
  }

  $args = $k3s::operation_mode ? {
    'server' => '--cluster-init',
    default  => '',
  }
  $command = "${script_path} ${k3s::operation_mode} ${args}"

  exec { $command:
    environment => [
      $version_env,
    ],
    require     => File[$script_path],
    subscribe   => [Archive[$script_path], File[$k3s_config], File[$k3s_version]],
    refreshonly => true,
  }
}
