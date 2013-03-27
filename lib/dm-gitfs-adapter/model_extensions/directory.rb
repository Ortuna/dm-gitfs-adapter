module DataMapper::Gitfs::Model
  module Directory

    def destroy
      return unless empty?
      FileUtils.rm_rf complete_path
      git_update_tree "Removed #{base_path}"
    end

    def destroy!
      FileUtils.rm_rf complete_path
      git_update_tree "Removed! #{base_path}"
    end

    def save
      rename_resource  if     should_rename?
      create_directory unless resource_exists?
      create_config    unless config_exists?

      git_update_tree "Updated #{base_path}"
    end

    private
    def rename_resource
      old_path = complete_path(original_base_path)
      new_path = complete_path
      FileUtils.mv old_path, new_path
    end

    def create_directory
      FileUtils.mkdir_p complete_path
      FileUtils.touch   "#{complete_path}/.gitignore"
    end

    def create_config
      fields = fields_to_hash
      return if (!fields || fields.empty?)
      ::File.open(config_path, 'w+') do |config_file|
         YAML.dump(fields, config_file)
      end
    end

    def fields_to_hash
      fields.inject({}) do |memo, field|
        field_name = field.name
        unless exclude_fields_from_config.include?(field_name)
          memo[field_name.to_s] = send(field_name)  
        end
        memo
      end
    end

    def exclude_fields_from_config
      [:base_path, :path, :complete_path]
    end

    def config_path
      "#{complete_path}/#{config_file}"
    end

    def config_exists?
      ::File.exists?(config_path)
    end

    def empty?
      #does not care about hidden files
      glob = Dir.glob("#{complete_path}/**/*")
      glob.empty? || glob == ["#{complete_path}/#{config_file}"]
    end

    def config_file
      "_config.yml"
    end

  end
end