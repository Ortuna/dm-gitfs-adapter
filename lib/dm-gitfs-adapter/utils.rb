module Gitfshelper

  def self.yaml_file_to_hash(file_path)
    config_hash = YAML::load(::File.open(file_path))
    return config_hash ? config_hash : {}
  rescue
    return {}
  end

  def self.yaml_to_hash(yaml)
    YAML::load(yaml)
  end

  def self.hash_to_yaml(hash)
    YAML::dump(hash)
  end
end