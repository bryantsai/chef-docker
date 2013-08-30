
# Cookbook Name:: docker
# Recipe:: registry
#
# Copyright (C) 2013 Jean-Francois Theroux
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'docker::user'
include_recipe 'nginx'

# dependencies
%w(make gcc openssl-devel python-devel libevent-devel python-pip).each { |pkg| package pkg}

# installation
[node[:docker][:registry][:basedir], node[:docker][:registry][:storagedir]].each do |dir|
  directory dir do
    recursive true
    owner 'docker'
    group 'docker'
  end
end

git node[:docker][:registry][:basedir] do
  user 'docker'
  group 'docker'
  repository 'https://github.com/dotcloud/docker-registry.git'
  reference node[:docker][:registry][:version]
end

execute 'pip install requirements' do
  command 'python-pip install -r requirements.txt'
  cwd node[:docker][:registry][:basedir]
end

# configuration
template "#{node[:docker][:registry][:basedir]}/config.yml" do
  owner 'docker'
  mode 0644
end

# init
template '/etc/init.d/docker-registry' do
  source 'init.erb'
  mode 0755
end

service 'docker-registry' do
  action [ :start, :enable ]
end

# nginx
if node[:docker][:registry][:nginx][:enable] == true
  include_recipe 'docker::nginx'
end
