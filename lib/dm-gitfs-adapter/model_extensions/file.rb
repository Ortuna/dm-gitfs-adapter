module DataMapper::Gitfs::Model
  module File

    def self.included(model)
      model.property :content, DataMapper::Property::Text
    end

    def destroy
      return unless resource_exists?
      destroy_resource 
      git_update_tree "Removed #{base_path}"
    end

    def save
      custom_save #for markdown to condense everything into @content
      check_existance!(complete_path) if new?
      rename_resource if     should_rename?
      create_resource unless resource_exists?
      write_content_to_file
      git_update_tree "Updated #{base_path}"
      true
    rescue
      false
    end

    def content
      @content ||= read_content_from_file
    end

    private
    def custom_save
      if respond_to?("save_#{model.resource_type}")
        send("save_#{model.resource_type}")
      end
    end

    def read_content_from_file
      ::File.open(complete_path, 'r') { |file| return file.read }
    rescue
      nil
    end

    def write_content_to_file
      ::File.open(complete_path, 'w') { |file| file.write(process_content(content)) }
    end

    def process_content(content)
      content << "\n"
      content.gsub! /\n+\Z/, "\n"
    end

  end
end