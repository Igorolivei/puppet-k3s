# @summary Class responsible for installing k3s
class k3s::install {
  case $k3s::installation_mode {
    'script': {
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
        default  => "--token ${token} ${k3s::custom_server_args}",
      }

      exec { "${script_path} ${k3s::operation_mode} ${args}":
        require     => File[$script_path],
        subscribe   => Archive[$script_path],
        refreshonly => true,
      }
    }

    'binary': {
      case $facts['os']['architecture'] {
        'amd64', 'x86_64': {
          $binary_arch = 'k3s'
          $checksum_arch = 'sha256sum-amd64.txt'
        }
        'arm64': {
          $binary_arch = 'k3s-arm64'
          $checksum_arch = 'sha256sum-arm64.txt'
        }
        'armhf': {
          $binary_arch = 'k3s-armhf'
          $checksum_arch = 'sha256sum-arm.txt'
        }
        default: {
          fail('No valid architecture provided.')
        }
      }
      $k3s_url = "https://github.com/rancher/k3s/releases/download/${k3s::binary_version}/${binary_arch}"
      $k3s_checksum_url = "https://github.com/rancher/k3s/releases/download/${k3s::binary_version}/${checksum_arch}"

      archive { $k3s::binary_path:
        ensure           => present,
        source           => $k3s_url,
        checksum_url     => $k3s_checksum_url,
        checksum_type    => 'sha256',
        cleanup          => false,
        creates          => $k3s::binary_path,
        download_options => '-S',
      }

      file { $k3s::binary_path:
        ensure  => file,
        mode    => '0755',
        require => [
          Archive[$k3s::binary_path],
        ],
      }
    }

    default: {
      fail('No valid installation mode provided.')
    }
  }
}
