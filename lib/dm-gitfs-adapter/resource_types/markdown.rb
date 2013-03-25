module DataMapper
  module Gitfs
    module Markdown

      private
      def read_markdown(query)
        records   = []
        params    = extract_query_params(query)
        root_path = params[:root_path] || @path
        Dir.glob("#{root_path}/**/*").each do |item|
          next if !::File.file?(item) || ::File.basename(item)[0] == '_'
          record  = query.model.new
          record.send(:path=, item)
          record.send(:base_path=, ::File.basename(item))
          load_markdown_data(record)
          records << record
        end
        set_parent_model(records, params) if params[:path_key]
        records
      end

      def set_parent_model(records, params)
        records.each do |record|
          record.send("#{params[:path_key]}=", params[:root_path])
        end
      end

      def load_markdown_data(record)
        markdown        = read_markdown_file(record.path)
        record.markdown = markdown if record.respond_to? :markdown
        record.metadata = extract_metadata(markdown) if record.respond_to? :metadata
      end
      
      def read_markdown_file(path)
        ::File.read(path) if ::File.exists?(path)
      end

      def read_config
        yaml_file_to_hash "#{self.path}"
      end

      def yaml_file_to_hash(file_path)
        config_hash = YAML::load(::File.open(file_path))
        return config_hash ? config_hash : {}
      rescue
        return {}
      end

      def extract_metadata(md)
        yaml_to_hash match_data(md, 1)
      rescue
        {}
      end

      def extract_markdown(md)
        match_data(md, 2)
      rescue
        ""
      end

      def yaml_to_hash(yaml)
        YAML::load(yaml)
      end

      def match_data(md, index)
        md.match(/-{3,}\s([\s\S]*?)-{3,}\s([\s\S]*)/)[index]
      end      
    end
  end
end