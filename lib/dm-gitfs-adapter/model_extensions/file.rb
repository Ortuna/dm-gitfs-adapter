module DataMapper::Gitfs::Model
  module File
    def self.included(model)
      model.property :content, DataMapper::Property::Text
    end

    def destroy
      destroy_resource if resource_exists?
    end

    def save
      send("save_#{model.resource_type}") if respond_to?("save_#{model.resource_type}")
      rename_or_create_resource
      write_content_to_file
    end

    def content
      @content ||= read_content_from_file
    end

    private
    def read_content_from_file
      ::File.open(complete_path, 'r') { |file| return file.read }
    end

    def write_content_to_file
      ::File.open(complete_path, 'w') { |file| file.write(content) }
    end 
  end
end