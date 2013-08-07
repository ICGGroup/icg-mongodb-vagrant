# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
awsconfig = YAML.load_file('awsconfig.yml')

Vagrant.configure("2") do |config|

  config.vm.hostname = "icg-dev-labs"
  
  config.vm.box = "ec2"

  config.vm.provider :aws do |aws, override|

    config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

    aws.access_key_id = awsconfig["aws_access_key_id"]
    aws.secret_access_key = awsconfig["aws_secret_access_key"]
    aws.keypair_name = awsconfig["aws_keypair_name"]

    aws.ami = "ami-fbd04dcb"
    aws.region = "us-west-2"
    aws.use_iam_profile = false
    aws.instance_type = "m1.small"
    aws.security_groups = ["icg-dev-group"]

    aws.user_data = File.read("user_data.txt")

    override.ssh.username = "ec2-user"
    override.ssh.private_key_path = awsconfig["aws_private_key_path"]

  end

  config.vm.provision :chef_solo do |chef|

    chef.json = {
        "icg" => {
            "git_url" => ""
        }
    }  

    chef.run_list = [
        "recipe[icg::mongodb]"
    ]

  end


end
