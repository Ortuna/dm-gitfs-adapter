module DataMapper
  module Gitfs
    module Markdown
      attr_accessor :metadata, :markdown
      def after_load
        @markdown = read_markdown
        @metadata = extract_metadata(@markdown)
      end

      private
      def read_markdown
        File.read(self.path) if File.exists?(self.path)
      end

      def read_config
        yaml_file_to_hash "#{self.path}"
      end

      def yaml_file_to_hash(file_path)
        config_hash = YAML::load(File.open(file_path))
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