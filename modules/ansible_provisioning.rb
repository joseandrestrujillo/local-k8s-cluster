module AnsibleProvisioning
    def self.provision_ansible(config, playbook, groups)
      config.vm.provision "ansible" do |ansible|
        ansible.playbook = playbook
        ansible.groups = groups
      end
    end
  end
  