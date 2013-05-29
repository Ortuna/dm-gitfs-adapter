module DataMapper
  module Gitfs
    module File

      private
      def read_file(query)
        params    = extract_query_params(query)
        root_path = params[:root_path] || @path
        records   = parse_directory_files(query.model, "#{root_path}/**/*")
        set_parent_model(records, params) if params[:path_key]
        records
      end

      def parse_directory_files(model, path)
        records = []
        Dir.glob(path).each do |item|
          next if !::File.file?(item) || ::File.basename(item)[0] == '_'
          records << init_object_from_path(model, item)
        end
        records
      end

      def init_object_from_path(model, item)
        model.new.tap do |record|
          record.send(:path=, item)
          record.send(:base_path=, ::File.basename(item))
        end
      end

      def set_parent_model(records, params)
        records.each do |record|
          record.send("#{params[:path_key]}=", params[:root_path])
        end
      end#def

    end# files
  end# gitfs
end# datamapper
