module DataMapper
  module Gitfs
    class Adapter < DataMapper::Adapters::AbstractAdapter

      include DataMapper::Gitfs::Directory
      include DataMapper::Gitfs::File

      def initialize(name, options)
        super
        verify_adapter_path_exists! options["path"]
        @path = options["path"]
      end

      def verify_adapter_path_exists!(path)
        path.sub! '://', ''
        raise 'Path not found' unless ::File.exists?(path)
      end

      def read(query)
        records = send("read_#{query.model.resource_type}", query)
        query.filter_records(records)
      end

      private
      def extract_query_params(query)
        return {} unless conditions = query.options[:conditions]
        conditions.each do |options, parent_model|
          next if parent_model.respond_to? :each
          next unless parent_model.class.resource_type == :directory
          return { :root_path => extract_root_path(parent_model),
                   :path_key  => extract_root_key_name(options) }
        end
      end

      def extract_root_key_name(options)
        options.child_key.first.name
      end

      def extract_root_path(parent_model)
        parent_model.path
      end

    end #class Adapter
  end #module Gitfs
end #module DataMapper