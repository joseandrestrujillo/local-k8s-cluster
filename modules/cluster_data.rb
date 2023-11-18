module ClusterData
    def self.get_cluster_data
        if !File.exist?("k8s-cluster.yml")
            File.open("k8s-cluster.yml", "w") do |file|
              file.puts({ "nodes" => [
                { "name": "master", "master": true, "memory": 2048, "cpus": 2 },
                { "name": "worker", "master": false, "memory": 2048, "cpus": 2 }
              ] }.to_yaml)
            end
          
            k8s_cluster_data = YAML.load_file("k8s-cluster.yml")
          else
            k8s_cluster_data = YAML.load_file("k8s-cluster.yml")
          
            if !k8s_cluster_data.has_key?("nodes")
              k8s_cluster_data["nodes"] = [
                { "name": "master", "master": true, "memory": 2048, "cpus": 2 },
                { "name": "worker", "master": false, "memory": 2048, "cpus": 2 }
              ]
          
              File.open("k8s-cluster.yml", "w") do |file|
                file.puts k8s_cluster_data.to_yaml
              end
          
              k8s_cluster_data = YAML.load_file("k8s-cluster.yml")
            end
          end

          return k8s_cluster_data
    end
end