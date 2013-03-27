module DataMapper
  module Gitfs
    module Resource

      include DataMapper::Gitfs::Model::Common

      def self.included(model)
        model.send(:include, DataMapper::Resource)

        model.extend self
        model.property :path,      String, :writer => :private, :key    => true
        model.property :base_path, String
      end

      def default_repository_name
        :gitfs
      end

      def resource_type(type = :unknown)
        return @resource_type if @resource_type
        if allowed_resource_types.include? type
          @resource_type ||= type
          include_model_specific_module(type) if allowed_resource_types[type]
        else
          raise "Unknown resource_type #{type}"
        end
        @resource_type
      end

      def repository_path
        repository.adapter.options["path"]
      end

      private
      def include_model_specific_module(type)
        self.send(:include, allowed_resource_types[type])
      end

      def allowed_resource_types
        { 
          :directory => DataMapper::Gitfs::Model::Directory,
          :file      => DataMapper::Gitfs::Model::File,
          :markdown  => DataMapper::Gitfs::Model::Markdown
        }
      end

    end
  end
end