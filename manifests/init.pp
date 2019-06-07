# @summary Manages installing and configuring g10k
#
# @param source_name
#   The primary source's name.
#
# @param source_remote
#   The primary source's remote url.
#
# @param source_basedir
#   The base directory to use for installing components.
#
# @param version
#   The version of g10k to install.
#   Default: '0.4.7'
#
# @param user
#   The user to execute the g10k command.
#   Default: 'root'
#
# @param cache_dir
#   The path to the cache directory.
#   Default: '/var/cache/g10k'
#
# @param maxworker
#   The number of Goroutines allowed to run in parallel for Git and Forge
#   module resolving
#
# @param maxextractworker
#   The number of Goroutines allowed to run in parallel for local Git
#   and Forge module extracting processes (git clone, untar and gunzip)
#
# @param is_quiet
#   If true, prints no output.
#
# @param use_cache_fallback
#   If g10k is unable to connect to remote source, the local cache is used.
#
# @param additional_settings
#   A hash of additional g10k.yaml settings that can be configured for a source.
#
# @param proxy_server
#   Web proxy for downloading g10k.
#
# @param postrun
#   Array of strings to be set as the postrun command.
#
# @param manage_git_package
#   If this class should manage the git package.
#
class g10k(
  String           $source_name,
  String           $source_remote,
  String           $source_basedir,
  String           $version             = '0.5.6',
  String           $user                = 'root',
  String           $cache_dir           = '/var/cache/g10k',
  Integer          $maxworker           = 50,
  Integer          $maxextractworker    = 20,
  Boolean          $is_quiet            = false,
  Boolean          $use_cache_fallback  = false,
  Optional[Hash]   $additional_settings = undef,
  Optional[String] $proxy_server        = undef,
  Array[String]    $postrun             = [],
  Boolean          $manage_git_package  = true,
){


  $g10k_file = "g10k-${version}-linux-amd64.zip"
  $g10k_url  = "https://github.com/xorpaul/g10k/releases/download/v${version}/g10k-linux-amd64.zip"

  # manage dependencies
  if $manage_git_package{
    $required_packages = ['wget','unzip','git']
  }else{
    $required_packages = ['wget','unzip']
  }

  ensure_packages($required_packages)
  include archive

  # download and install g10k
  archive{"/usr/local/share/g10k/${g10k_file}":
    source       => $g10k_url,
    proxy_server =>  $proxy_server,
    extract      => true,
    extract_path => '/usr/local/bin',
    cleanup      => true,
  }

  # ensure the file has executable permissions
  file{'/usr/local/bin/g10k':
    ensure  => file,
    mode    => '0755',
    require => Archive["/usr/local/share/g10k/${g10k_file}"],
  }

  # manage cache directory
  file{$cache_dir:
    ensure  => directory,
    owner   => $user,
    mode    => '0775',
    require => File['/usr/local/bin/g10k'],
  }

  file{'/etc/g10k.yaml':
    ensure  => file,
    content => epp('g10k/g10k.yaml.epp',{
      cache_dir           => $cache_dir,
      source_name         => $source_name,
      source_remote       => $source_remote,
      source_basedir      => $source_basedir,
      use_cache_fallback  => $use_cache_fallback,
      additional_settings => $additional_settings,
      postrun             => $postrun,
    }),
    require => File[$cache_dir],
  }

  file{'/usr/local/bin/g10k.bash':
    ensure  => file,
    mode    => '0755',
    content => epp('g10k/g10k.bash.epp',{
      maxworker        => $maxworker,
      maxextractworker => $maxextractworker,
      is_quiet         => $is_quiet,
    }),
    require => File['/etc/g10k.yaml'],
  }
}
