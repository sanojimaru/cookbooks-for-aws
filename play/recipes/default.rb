#
# Cookbook Name:: play
# Recipe:: default
#
# Copyright 2013, sanojimaru
#
# All rights reserved - Do Not Redistribute
#
user = "nginx"
group = "nginx"
play_version = "2.1.3"
play_prefix = "play-"
play_install_dir = "/opt/www"
play_home = "#{play_install_dir}/#{play_prefix}#{play_version}"
play_archive_filename = "#{play_prefix}#{play_version}.zip"
play_archive_filepath = "#{Chef::Config[:file_cache_path]}/#{play_archive_filename}"
play_source_url = "http://downloads.typesafe.com/play/#{play_version}/#{play_archive_filename}"

packages = [
  "java-1.7.0-openjdk",
  "mysql55-devel",
  "mysql55-libs",
  "mysql-connector-java",
  "nginx",
].each do |pkg|
  package pkg do
    action :install
  end
end

remote_file play_archive_filepath do
  source play_source_url
end

directory play_install_dir do
  owner user
  group group
  mode "0755"
  recursive true
  action :create
end

execute "unzip #{play_archive_filepath} -d #{play_install_dir}" do
  user user
  group group
  action :run
  not_if{ File.exists?(play_home) }
end

template "/etc/profile.d/play.sh" do
  source "play.sh.erb"
  mode 0755
  owner "root"
  group "root"
  variables({
    :play_home => play_home
  })
end
