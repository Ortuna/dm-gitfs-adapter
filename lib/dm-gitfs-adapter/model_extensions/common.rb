module DataMapper::Gitfs::Model
  module Common
    
    def path
      @path ||= complete_path
    end

    private
    def rename_or_create_resource
      rename_resource if     should_rename?
      create_resource unless resource_exists?
    end

    def complete_path(base_path = self.base_path)
      return if !base_path
      complete_path = "#{repository.adapter.path}/#{base_path}"
      complete_path = ::File.expand_path(complete_path)
    end

    def destroy_resource
      FileUtils.remove_entry complete_path
    end

    def create_resource
      FileUtils.touch complete_path
    end

    def create_directory
      FileUtils.mkdir complete_path
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
      FileUtils.mv old_path, new_path
    end 

    def original_base_path
      original_attributes.each do |attr, value|
        return value if attr.name == :base_path
      end
    end    
  end
end