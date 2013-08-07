#
# Cookbook Name:: icg-labs
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#


directory "/home/ec2-user/icg" do
  owner "ec2-user"
  mode 0755
  recursive true
end

bash "pull repository" do
  user "ec2-user"
  cwd "/home/ec2-user/icg/MGM-Foundation"
  code <<-EOH
  git pull
  EOH
  only_if { ::File.exists?("/home/ec2-user/icg/MGM-Foundation/readme.md") }
end


bash "clone repository" do
  user "ec2-user"
  cwd "/home/ec2-user/icg"
  code <<-EOH
  git clone https://trimeego:starbucks#766@github.com/ICGGroup/MGM-Foundation.git
  EOH
  not_if { ::File.exists?("/home/ec2-user/icg/MGM-Foundation/readme.md") }
end


