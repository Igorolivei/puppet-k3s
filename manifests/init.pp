# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include k3s
class k3s (
  Enum['present', 'absent'] $ensure,
  Enum['script', 'binary'] $installation_mode,
  Optional[Enum['amd64', 'arm64', 'armhf']] $binary_arch,
  Optional[String] $binary_version,
  Optional[String] $binary_path,
) {
  if $installation_mode == 'binary' and (!$binary_path or !$binary_version) {
    fail('The vars $binary_version and $binary_path must be set when using the \
      script installation mode.')
  }

  if $ensure == 'present' {
    include k3s::install
  } else {
    include k3s::uninstall
  }
}
