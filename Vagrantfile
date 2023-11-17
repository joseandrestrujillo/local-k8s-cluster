# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

if !File.exist?("k8s_cluster.yml")
  File.open("k8s_cluster.yml", "w") do |file|
    file.puts({ "nodes" => [
      { "name": "master", "master": true, "memory": 2048, "cpus": 2 },
      { "name": "worker", "master": false, "memory": 2048, "cpus": 2 }
    ] }.to_yaml)
  end

  k8s_cluster_data = YAML.load_file("k8s_cluster.yml")
else
  k8s_cluster_data = YAML.load_file("k8s_cluster.yml")

  if !k8s_cluster_data.has_key?("nodes")
    k8s_cluster_data["nodes"] = [
      { "name": "master", "master": true, "memory": 2048, "cpus": 2 },
      { "name": "worker", "master": false, "memory": 2048, "cpus": 2 }
    ]

    File.open("k8s_cluster.yml", "w") do |file|
      file.puts k8s_cluster_data.to_yaml
    end

    k8s_cluster_data = YAML.load_file("k8s_cluster.yml")
  end
end

ip_address_counter = IPAddr.new("192.168.0.2")


mac_address_prefix = "A8D3B5DD3"
mac_address_counter = 0


k8s_cluster_data["nodes"].each do |node_data|
  node_name = node_data["name"]

  node_type = node_data["master"] ? "master" : "worker"

  node_memory = node_data["memory"] || 2048

  node_cpus = node_data["cpus"] || 2

  node_ip_address = ip_address_counter.to_ip.to_s
  ip_address_counter = ip_address_counter.succ

  node_mac_address = (mac_address_prefix + format("%04d", mac_address_counter)).upcase
  mac_address_counter += 1
  
  Vagrant.configure("2") do |config|
    config.vm.define node_name do |node|
      node.vm.box = "ubuntu/focal64"
      node.vm.hostname = node_name
      node.vm.box_check_update = true
      node.vm.network "private_network", ip: node_ip_address, mac: node_mac_address
      node.vm.provider "virtualbox" do |vb|
        vb.memory = node_memory
        vb.cpus = node_cpus
      end
    end
  end
end

Vagrant.configure("2") do |config|
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/install-dependencies.yml"
    ansible.groups = {
      "masters" => k8s_cluster_data["nodes"].select { |node| node["master"] }.map(&:name),
      "workers" => k8s_cluster_data["nodes"].reject { |node| node["master"] }.map(&:name)
    }
  end
end
