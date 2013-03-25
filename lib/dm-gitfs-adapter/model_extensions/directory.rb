module DataMapper::Gitfs::Model
  module Directory
    def self.included(model)

    end

    def save
      rename_resource  if     should_rename?
      create_directory unless resource_exists?
    end
  end
end