Vagrant.configure("2") do |config|
  config.vm.hostname = "docker-berkshelf"
  config.vm.box = "centos64-64-chef11"
  config.vm.box_url = "http://static.theroux.ca/vagrant/boxes/rhel64-64-chef11.box"
  config.ssh.max_tries = 40
  config.ssh.timeout   = 120
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      "grub" => {
        "kernel" => {
          "automatic_reboot" => true,
          "version_to_boot" => "Red Hat Enterprise Linux Server (3.10.5-3.el6.x86_64)"
        }
      }
    }

    chef.run_list = [
        "recipe[docker::default]"
    ]
  end
end
