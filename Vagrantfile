# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

require_relative "modules/cluster_data"
require_relative "modules/nodes"

k8s_cluster_data = ClusterData.get_cluster_data

Vagrant.configure("2") do |config|
  Nodes.define_nodes(config, k8s_cluster_data)

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/install-dependencies.yml"
    ansible.groups = {
      "masters" => k8s_cluster_data["nodes"].select { |node| node["master"] }.map { |node| node["name"] },
      "workers" => k8s_cluster_data["nodes"].reject { |node| node["master"] }.map { |node| node["name"] }
    }
  end
end
