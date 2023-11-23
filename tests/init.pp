class { 'g10k':
  version                    => '0.8.9',
  cache_dir                  => '/var/cache/g10k',
  source_name                => 'example',
  source_remote              => 'https://bitbucket.org/landcareresearch/g10k-environment.git',
  source_basedir             => '/etc/puppetlabs/code/environments',
  user                       => 'root',
  maxworker                  => 5,
  maxextractworker           => 5,
  is_quiet                   => false,
  use_cache_fallback         => true,
  deployment_purge_whitelist => ['.resource_types'],
  use_generate_types         => true,
}
