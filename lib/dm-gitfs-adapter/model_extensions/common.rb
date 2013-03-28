module DataMapper::Gitfs::Model
  module Common
    
    def repo
      repository.adapter.repo
    end

    def path
      @path ||= complete_path
    end

    private
    def complete_path(base_path = self.base_path)
      return if !base_path
      complete_path = ::File.expand_path(complete_path_with_relationship(base_path))
    end

    def complete_path_with_relationship(base_path = self.base_path)
      if(parent_model = parent_model_extract)
        "#{repository.adapter.path}/#{parent_model.base_path}/#{base_path}"
      else
        "#{repository.adapter.path}/#{base_path}"
      end
    end

    def parent_model_extract
      relationships.entries.each do |relationship|
        next unless relationship.class == DataMapper::Associations::ManyToOne::Relationship
        parent_model = instance_variable_get(relationship.instance_variable_name)
        next unless parent_model.model.resource_type == :directory
        return parent_model
      end
      nil
    rescue
      nil
    end

    def destroy_resource
      FileUtils.remove_entry complete_path
    end

    def create_resource
      FileUtils.mkdir_p ::File.dirname(complete_path)
      FileUtils.touch complete_path
    end

    def resource_exists?
      ::File.exists? complete_path
    end

    def should_rename?
      attribute_dirty?(:base_path) && !new?
    end

    def rename_resource
      old_path = complete_path(original_base_path)
      new_path = complete_path
      check_existance! new_path

      if ::File.dirname(old_path) != ::File.dirname(new_path)
        FileUtils.mkdir_p ::File.dirname(new_path)
      end
      FileUtils.mv old_path, new_path
    end
    
    def check_existance!(path)
      raise 'Path already exists' if ::File.exists? path
    end

    def original_complete_path
      complete_path original_base_path
    end

    def original_base_path
      original_attributes.each { |attr, v| return v if attr.name == :base_path }
    end # original_base_path

  end # Common
end # Module