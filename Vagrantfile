# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

execution_dir = File.expand_path('.')
script_dir = File.expand_path(File.dirname(__FILE__))


require File.expand_path(File.join(script_dir, "modules/cluster_data"))
require File.expand_path(File.join(script_dir, "modules/nodes"))
require File.expand_path(File.join(script_dir, "modules/ansible_provisioning"))


k8s_cluster_data = ClusterData.get_cluster_data(execution_dir)

Vagrant.configure("2") do |config|
  Nodes.define_nodes(config, k8s_cluster_data)

  node_groups = {
    "masters" => k8s_cluster_data["nodes"].select { |node| node["master"] }.map { |node| node["name"] },
    "workers" => k8s_cluster_data["nodes"].reject { |node| node["master"] }.map { |node| node["name"] }
  }

  AnsibleProvisioning.provision_ansible(config, File.expand_path(File.join(script_dir, "ansible/install-dependencies.yml")), node_groups)
end
