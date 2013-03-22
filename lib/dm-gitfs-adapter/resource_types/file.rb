module DataMapper
  module Gitfs
    module File

      private
      def read_file(query)
        records   = []
        params    = extract_query_params(query)
        root_path = params[:root_path] || @path
        Dir.glob("#{root_path}/**/*").each do |item|
          next if !::File.file?(item) || ::File.basename(item)[0] == '_'
          record      = query.model.new
          record.path = item
          records << record
        end
         apply_parent_condition(records, params) if params[:path_key]
         records
      end

      def apply_parent_condition(records, params)
        records.each do |record|
          record.send("#{params[:path_key]}=", params[:root_path])
        end
      end#def

    end# files
  end# gitfs
end# datamapper