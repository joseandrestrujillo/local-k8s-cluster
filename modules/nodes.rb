module Nodes
    def self.define_nodes(config, cluster_data)

        ip_address_counter = IPAddr.new("192.168.56.2")

        mac_address_prefix = "A8D3B5DD3"
        mac_address_counter = 0

        cluster_data["nodes"].each do |node_data|
            node_name = node_data["name"]

            node_type = node_data["master"] ? "master" : "worker"

            node_memory = node_data["memory"] || 2048

            node_cpus = node_data["cpus"] || 2

            node_ip_address = ip_address_counter.to_s
            ip_address_counter = ip_address_counter.succ
            
            node_mac_address = (mac_address_prefix + format("%03d", mac_address_counter)).upcase
            mac_address_counter += 1

            define_node(config, node_name, node_type, node_memory, node_cpus, node_ip_address, node_mac_address)
        end
    end

    def self.define_node(config, node_name, node_type, node_memory, node_cpus, node_ip_address, node_mac_address)
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