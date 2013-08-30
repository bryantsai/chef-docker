default[:docker][:kernel][:version] = '3.10.5-3.el6.x86_64'
default[:docker][:init] = 'monit'

# registry
default[:docker][:registry][:flavor] = 'prod'
default[:docker][:registry][:basedir] = '/opt/docker-registry'
default[:docker][:registry][:storagedir] = '/data/docker-registry'
default[:docker][:registry][:version] = '0.5.9'
default[:docker][:registry][:nginx][:enable] = true
