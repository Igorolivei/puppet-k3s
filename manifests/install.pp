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
  $args = $k3s::operation_mode ? {
    'agent'  => "--token ${token} --server ${$k3s::server} ${k3s::custom_agent_args}",
    default  => "--token ${token} --server ${$k3s::server} ${k3s::custom_server_args}",
  }
  if $k3s::version == 'stable' or $k3s::version == 'latest' {
    $version_env = "INSTALL_K3S_CHANNEL=${k3s::version}"
  } else {
    $version_env = "INSTALL_K3S_VERSION=${k3s::version}"
  }
  $command = "${script_path} ${k3s::operation_mode} ${args}"

  exec { $command:
    environment => [
      $version_env,
    ],
    require     => File[$script_path],
    subscribe   => Archive[$script_path],
    refreshonly => true,
  }
}
