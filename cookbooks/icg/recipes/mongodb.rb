


# mkdir -p /home/[user]/source
directory "/home/#{node[:icg][:root_user]}/source" do
  owner "ec2-user"
  mode 0755
  recursive true
end

# wget file from server
cookbook_file "/home/#{node[:icg][:root_user]}/source/mongodb.tgz" do 
  owner "ec2-user"
  mode 0755  
end

bash "extract and copy mongodb" do
  user "ec2-user"
  cwd "/home/#{node[:icg][:root_user]}/source"
  code <<-EOH
  tar -zxvf mongodb.tgz
  sudo cp mongodb-linux-x86_64-rhel57-v2.4-2013-08-05/bin/* /usr/bin
  EOH
  not_if { ::File.exists?("/usr/bin/mongod") }
end

# sudo groupadd mongod
group "mongod" do
  action :create
end

# sudo useradd -c 'Mongo DB User' -G 'mongod' mongod
user "mongod" do
  supports :manage_home => false
  comment "Mongo DB User"
  gid "mongod"
end

# sudo mkdir -p /var/run/mongodb
# sudo chown mongod:mongod /var/run/mongodb
directory "/var/run/mongodb" do
  owner "mongod"
  group "mongod"
  mode 0755
  recursive true
end

# sudo mkdir -p /var/log/mongo
# sudo chown mongod:mongod /var/log/mongo
directory "/var/log/mongo" do
  owner "mongod"
  group "mongod"
  mode 0755
  recursive true
end

# sudo mkdir -p /var/lib/mongo
# sudo chown mongod:mongod /var/lib/mongo
directory "/var/lib/mongo" do
  owner "mongod"
  group "mongod"
  mode 0755
  recursive true
end

# wget file from server and copy to '/etc/rc.d/init.d/mongod'
cookbook_file "/etc/rc.d/init.d/mongod" do
  source "mongodb.init"
  owner "mongod"
  group "mongod"
  mode 0755
end

# wget file from server and copy to '/etc/mongod.conf'
cookbook_file "/etc/mongod.conf" do
  owner "mongod"
  group "mongod"
  mode 0755
end

bash "ensure mongo starts on reboot and start" do
  user "ec2-user"
  code <<-EOH
  sudo chkconfig mongod on
  sudo service mongod start
  EOH
end

