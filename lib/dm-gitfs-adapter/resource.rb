module DataMapper
  module Gitfs
    module Resource
      
      def self.included(model)
        model.send(:include, DataMapper::Resource)
        model.extend self
        model.property :path,      String, :key    => true, :writer => :private
        model.property :base_path, String, :writer => :private
      end
      
      def default_repository_name
        :gitfs
      end

      def resource_type(type = :directory)
        if allowed_resource_types.include? type
          @resource_type ||= type
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
        [:directory, :file, :markdown]
      end

    end
  end
end