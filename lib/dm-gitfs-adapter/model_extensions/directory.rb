module DataMapper::Gitfs::Model
  module Directory

    def self.included(model)

    end

    def destroy
      return unless empty?
      FileUtils.rm_rf complete_path
      git_update_tree "Removed #{base_path}"
    end

    def save
      rename_resource  if     should_rename?
      create_directory unless resource_exists?
      git_update_tree "Updated #{base_path}"
    end

    def rename_resource
      old_path = complete_path(original_base_path)
      new_path = complete_path

      FileUtils.mv old_path, new_path
    end

    def create_directory
      FileUtils.mkdir_p complete_path
      FileUtils.touch   "#{complete_path}/.gitignore"
    end

    private
    def empty?
      #does not care about hidden files
      Dir.glob("#{complete_path}/**/*").empty?
    end

  end
end