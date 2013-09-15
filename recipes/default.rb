#
# Cookbook Name:: docker
# Recipe:: default
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
include_recipe 'yum'

yum_repository 'hop5' do
  repo_name 'hop5'
  description 'Hop5'
  url 'http://www.hop5.in/yum/el6/'
end

# Only install the kernel-devel package if we're
# inside Vagrant.
if Chef::Config[:solo]
  package 'kernel-ml-aufs-devel'
end

%w(docker-io xz).each { |pkg| package pkg }

include_recipe 'grub'

# Chef doesn't support cgroup yet with the mount resource. Need to manually
# enable it and then mount it.
#
# http://tickets.opscode.com/browse/CHEF-3372
execute 'enable cgroup mnt' do
  command "echo 'none                    /sys/fs/cgroup          cgroup  defaults        0 0' >> /etc/fstab"
  only_if { node[:kernel][:release] == node[:docker][:kernel][:version] }
  not_if "grep cgroup /etc/fstab"
end

execute 'mount cgroup' do
  command "mount /sys/fs/cgroup"
  only_if { node[:kernel][:release] == node[:docker][:kernel][:version] }
  not_if "mount | grep cgroup"
end

# init
case node[:docker][:init]
  when 'monit'
    include_recipe 'docker::monit'
end

# ip forwarding
execute 'manually enable ip forwarding' do
  command 'sysctl -w net.ipv4.ip_forward=1'
  not_if "sysctl -a | grep 'net.ipv4.ip_forward = 1'"
end

execute 'permanently enabling ip forwarding' do
  command "echo 'net.ipv4.ip_forward = 1 # configured by Chef' >> /etc/sysctl.conf"
  not_if "grep '^net.ipv4.ip_forward = 1' /etc/sysctl.conf"
end
