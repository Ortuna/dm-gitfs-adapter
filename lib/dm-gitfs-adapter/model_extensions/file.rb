module DataMapper::Gitfs::Model
  module File
    def self.included(model)
      model.property :content, DataMapper::Property::Text
    end

    def path
      @path ||= complete_path
    end

    def save
      send("save_#{model.resource_type}") if respond_to?("save_#{model.resource_type}")
      rename_file if     should_rename?
      create_file unless file_exists?
      write_content_to_file
      true
    rescue
      false
    end

    def destroy
      destroy_file if file_exists?
    end

    def content
      @content ||= read_content_from_file
    end

    private

    def rename_file
      old_path = complete_path(original_base_path)
      new_path = complete_path
      FileUtils.mv old_path, new_path
    end

    def read_content_from_file
      ::File.open(complete_path, 'r') { |file| return file.read }
    end

    def write_content_to_file
      ::File.open(complete_path, 'w') { |file| file.write(content) }
    end

    def original_base_path
      original_attributes.each do |attr, value|
        return value if attr.name == :base_path
      end
    end

    def complete_path(base_path = self.base_path)
      return if !base_path
      complete_path = "#{repository.adapter.path}/#{base_path}"
      complete_path = ::File.expand_path(complete_path)
    end

    def destroy_file 
      FileUtils.remove_file complete_path
    end

    def create_file
      FileUtils.touch complete_path
    end

    def file_exists?
      ::File.exists? complete_path
    end

    def should_rename?
      attribute_dirty?(:base_path) && !new?
    end    
  end
end