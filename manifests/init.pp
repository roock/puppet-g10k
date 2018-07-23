# @summary Manages installing and configuring g10k
#
# @param [String] source_name
#   The primary source's name.
#
# @param [String] source_remote
#   The primary source's remote url.
#
# @param [String] source_basedir
#   The base directory to use for installing components.
#
# @param [String] version
#   The version of g10k to install.
#   Default: '0.4.7'
#
# @param [String] user
#   The user to execute the g10k command.
#   Default: 'root'
#
# @param [String] cache_dir
#   The path to the cache directory.
#   Default: '/var/cache/g10k'
#
# @param [Integer] maxworker
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
class g10k(
  String  $source_name,
  String  $source_remote,
  String  $source_basedir,
  String  $version          = '0.4.7',
  String  $user             = 'root',
  String  $cache_dir        = '/var/cache/g10k',
  Integer $maxworker        = 50,
  Integer $maxextractworker = 20,
  Boolean $is_quiet         = false,
){

  anchor{'g10k::begin':}

#CACHEDIR="puppet/g10k_cache"
#PUPPETFILE="puppet-control/Puppetfile"
#./g10k -cachedir=$CACHEDIR -puppetfile -puppetfilelocation $PUPPETFILE -moduledir puppet/modules

#G10K_FILE=g10k-linux-amd64.zip
#G10K_URL=https://github.com/xorpaul/g10k/releases/download/v${G10K_VERSION}/${G10K_FILE}
#wget -P /tmp $G10K_URL
#unzip /tmp/${G10K_FILE}

  $g10k_file = 'g10k-linux-amd64.zip'
  $g10k_url  = "https://github.com/xorpaul/g10k/releases/download/\
v${version}/${g10k_file}"

  # manage dependencies
  $required_packages = ['wget','unzip','git']
  ensure_packages($required_packages)
  include archive

  # download and install g10k
  archive{"/usr/local/share/g10k/${g10k_file}":
    source       => $g10k_url,
    extract      => true,
    extract_path => '/usr/local/bin',
    cleanup      => true,
    require      => [Anchor['g10k::begin'],
                    Package[$required_packages]],
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
      cache_dir      => $cache_dir,
      source_name    => $source_name,
      source_remote  => $source_remote,
      source_basedir => $source_basedir,
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

  anchor{'g10k::end':
    require => File['/usr/local/bin/g10k.bash'],
  }
}