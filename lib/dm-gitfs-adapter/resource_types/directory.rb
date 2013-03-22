module DataMapper
  module Gitfs
    module Directory

      private
      def read_directory(query)
        records   = []
        params    = extract_query_params(query)
        root_path = params[:root_path] || @path

        Dir.glob("#{root_path}/**").each do |item|
          next unless ::File.directory?(item)
          record      = query.model.new
          record.path = item
          apply_config(record, load_directory_config(item))
          records << record
        end
        records
      end

      def apply_config(record, options)
        return unless options
        options.each do |option, value|
          if record.respond_to? "#{option}="
            record.public_send("#{option}=".to_sym, value)
          end
        end
      end

      def load_directory_config(conf_path)
        conf_path = "#{conf_path}/_config.yml" unless ::File.file?(conf_path)
        return unless ::File.exists?(conf_path)
        YAML::load_file(conf_path)
      end

    end
  end
end