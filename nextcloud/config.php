<? php
$CONFIG = array (
  'instanceid' => '',
  'passwordsalt' => '',
  'secret' => '',
  'trusted_domains' => 
  array (
    0 => '',
    1 => '',
  ),
  'datadirectory' => '',
  'dbtype' => 'mysql',
  'version' => '20.0.',
  'overwrite.cli.url' => 'https://',
  'overwriteprotocol' => 'https',
  'dbname' => '',
  'dbhost' => '',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'nextcloud',
  'dbpassword' => '',
  'installed' => true,
  'trusted_proxies' => 
  array (
    0 => '',
    1 => '',
  ),
  'forwarded_for_headers' => 
  array (
    0 => 'HTTP_X_FORWARDED_FOR',
  ),
  'log_type' => 'file',
  'logfile' => '/var/log/nextcloud/nextcloud.log',
  'loglevel' => 2,
  'filelocking.enabled' => true,
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'redis' => 
  array (
    'host' => '',
    'port' => 6379,
    'timeout' => 1.5,
    'password' => '',
  ),
  'maintenance' => false,
  'theme' => '',
  'default_phone_region' => 'SA',
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/nextcloud/apps',
      'url' => '/apps',
      'writable' => true,
    ),
    1 => 
    array (
      'path' => '/var/www/nextcloud/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'allow_local_remote_servers' => true,
);
