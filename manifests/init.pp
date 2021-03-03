# @summary Installs and configures the OCS inventory agent package for the operating system
# @see https://forge.puppet.com/puppet/zypprepo Used component module for Zypper Repository
# @param ensure Ensure wether the package is installed or not
# @param package_name The name of the ocsinventory-agent package
# @param daemon detach the agent in background
# @param debug debug mode
# @param devlib search for Backend mod in ./lib only
# @param force always send data to server (Don't ask before)
# @param info verbose mode
# @param lazy do not contact the server more than one time during the PROLOG_FREQ
# @param local do not contact server but write inventory in DIR directory in XML
# @param logfile log message in this file
# @param password password for server auth
# @param proxy proxy address. e.g: http://user:pass\@proxy:port
# @param realm realm for server auth. e.g: 'Restricted Area'
# @param server server uri
# @param stdout do not write or post the inventory but print it on STDOUT
# @param ocstag Use tag for ocs
# @param user user for server auth
# @param wait wait a random period before contacting server like --daemon does
# @param nosoftware do not return installed software list
# @param delaytime set a max delay time (in second) if no PROLOG_FREQ is set
# @param backendCollectTimeout set a max delay time of one action (search package id, ...) is set
# @param scanhomedirs permit to scan home user directories
# @param ssl disable or enable SSL communications check
# @param ca path to CA certificates file in PEM format
# @param repo_dependencies A list of package dependencies required to install before the dependencies
# @param dependencies A list of package dependencies required to install OCS inventory package
# @param zypper_repo_url URL of Zypper Repository for SLES systems
class ocsinventoryagent (
  Enum['present', 'absent'] $ensure = 'present',
  String $package_name              = 'ocsinventory-agent',
  Enum['0', '1']  $daemon           = '0',
  Enum['0', '1']  $debug            = '0',
  Enum['0', '1']  $devlib           = '0',
  Enum['0', '1']  $force            = '0',
  Enum['0', '1']  $info             = '1',
  Enum['0', '1']  $lazy             = '0',
  String $local                     = '',
  String $logfile                   = '',
  String $password                  = '',
  String $proxy                     = '',
  String $realm                     = '',
  String $server                    = 'http://ocsinventory-ng/ocsinventory',
  Enum['0', '1']  $stdout           = '0',
  String $ocstag                    = '',
  String $user                      = '',
  String $wait                      = '',
  Enum['0', '1']  $nosoftware       = '0',
  String $delaytime                 = '3600',
  String $backendcollecttimeout     = '600',
  Enum['0', '1']  $scanhomedirs     = '0',
  Enum['0', '1']  $ssl              = '1',
  String $ca                        = '',
  Optional[Hash] $repo_dependencies = undef,
  Optional[Hash] $dependencies      = undef,
  Optional[String] $zypper_repo_url = undef,
) {
  if ($facts['os']['family'] == 'Suse' and $zypper_repo_url) {
    zypprepo { 'ocsinventory-repo':
      baseurl      => $zypper_repo_url,
      enabled      => 1,
      autorefresh  => 1,
      name         => 'OCS Inventory Agent',
      gpgcheck     => 0,
      priority     => 98,
      keeppackages => 1,
      type         => 'rpm-md',
      before       => Package[$package_name]
    }
  }

  Package <| tag == 'repo_dependenceis' |> -> Package<| tag == 'dependencies' |>

  if ($repo_dependencies) {
    create_resources('package', $repo_dependencies, {
      tag => ['repo_dependencies']
    })
  }

  if ($dependencies) {
    create_resources('package', $dependencies, {
      ensure => $ensure,
      before => Package[$package_name],
      tag    => ['dependencies']
    })
  }

  $_dirensure = $ensure ? {
    'present' => 'directory',
    'absent'  => 'absent',
  }

  $_fileensure = $ensure ? {
    'present' => 'file',
    'absent'  => 'absent'
  }

  package {
    $package_name:
      ensure => $ensure,
  }

  -> file {
    '/etc/ocsinventory':
      ensure => $_dirensure
  }

  -> file {
    '/etc/ocsinventory/ocsinventory-agent.cfg':
      ensure  => $_fileensure,
      content => epp(
        'ocsinventoryagent/ocsinventory-agent.cfg.epp',
        {
          daemon                => $daemon,
          debug                 => $debug,
          devlib                => $devlib,
          force                 => $force,
          info                  => $info,
          lazy                  => $lazy,
          local                 => $local,
          logfile               => $logfile,
          password              => $password,
          proxy                 => $proxy,
          realm                 => $realm,
          server                => $server,
          stdout                => $stdout,
          ocstag                => $ocstag,
          user                  => $user,
          wait                  => $wait,
          nosoftware            => $nosoftware,
          delaytime             => $delaytime,
          backendcollecttimeout => $backendcollecttimeout,
          scanhomedirs          => $scanhomedirs,
          ssl                   => $ssl,
          ca                    => $ca,
        }
      )
  }
}
