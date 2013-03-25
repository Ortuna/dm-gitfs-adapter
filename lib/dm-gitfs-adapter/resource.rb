module DataMapper
  module Gitfs
    module Resource

      def self.included(model)
        model.send(:include, DataMapper::Resource)
        model.send(:include, DataMapper::Gitfs::Git)

        model.extend self
        model.property :path,      String, :writer => :private, :key    => true
        model.property :base_path, String, :writer => :private
      end

      def default_repository_name
        :gitfs
      end

      def resource_type(type = :directory)
        if allowed_resource_types.include? type
          @resource_type ||= type
          self.send(:include, allowed_resource_types[type]) if  allowed_resource_types[type]
        else
          raise "Unknown resource_type #{type}"
        end
        @resource_type
      end

      def repository_path
        repository.adapter.options["path"]
      end

      private
      def allowed_resource_types
        { 
          :directory => nil,
          :file      => nil,
          :markdown  => DataMapper::Gitfs::Model::Markdown
        }
      end

    end
  end
end