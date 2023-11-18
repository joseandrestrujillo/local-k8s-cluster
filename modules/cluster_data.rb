module ClusterData
    def self.get_cluster_data(execution_dir)
        file_dir = File.expand_path(File.join(execution_dir, "k8s-cluster.yml"))

        if !File.exist?(file_dir)
            File.open(file_dir, "w") do |file|
              file.puts({ "nodes" => [
                { "name": "master", "master": true, "memory": 2048, "cpus": 2 },
                { "name": "worker", "master": false, "memory": 2048, "cpus": 2 }
              ] }.to_yaml)
            end
          
            k8s_cluster_data = YAML.load_file(file_dir)
          else
            k8s_cluster_data = YAML.load_file(file_dir)
          
            if !k8s_cluster_data.has_key?("nodes")
              k8s_cluster_data["nodes"] = [
                { "name": "master", "master": true, "memory": 2048, "cpus": 2 },
                { "name": "worker", "master": false, "memory": 2048, "cpus": 2 }
              ]
          
              File.open(file_dir, "w") do |file|
                file.puts k8s_cluster_data.to_yaml
              end
          
              k8s_cluster_data = YAML.load_file(file_dir)
            end
          end

          return k8s_cluster_data
    end
end