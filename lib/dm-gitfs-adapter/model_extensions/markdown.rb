module DataMapper::Gitfs::Model
  module Markdown

    def self.included(model)
      #file model is common to markdown
      model.property :metadata, Class
      model.property :markdown, String
      model.send(:include, DataMapper::Gitfs::Model::File)      
    end

    def save_markdown
      self.content = metadata_for_content + markdown_for_content
    end

    private
    def metadata_for_content
      """ #{Gitfshelper.hash_to_yaml(metadata_hash)}
      ----------
      """
    end

    def markdown_for_content
      markdown || ""
    end

    def metadata_hash
      hash = attributes.inject({}) do |memo, (key,value)|
        memo[key] = value unless excluded_hash_keys.include? key
        memo
      end

      if metadata && metadata.respond_to?(:each)
        metadata.merge(hash)
      else
        hash
      end
    end

    def excluded_hash_keys
      [:metadata, :markdown, :content, :path, :base_path]
    end
  end
end