module DataMapper
  module Gitfs
    module Resource
      
      def self.included(model)
        extend_and_include_modules model
        add_default_properties     model
      end

      private
      def self.extend_and_include_modules(model)
        model.send(:include, DataMapper::Resource)
        model.extend self
      end

      def self.add_default_properties(model)
        model.property :path, String, :key => true
      end

      #TODO: SEPERATE!
      
      public
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
        [:directory, :file]
      end

    end
  end
end