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
      output = "#{Gitfshelper.hash_to_yaml(metadata_hash)}"
      output << "----\n"
      output
    end

    def markdown_for_content
      markdown || ""
    end

    def metadata_hash
      excluded_keys = excluded_hash_keys + parent_keys
      hash = attributes.inject({}) do |memo, (key,value)|
        memo[key] = value unless excluded_keys.include? key
        memo
      end
      hash = metadata.merge(hash) if metadata.respond_to?(:each)
      stringify_keys(hash)
    end

    def stringify_keys(hash)
      return hash unless hash.respond_to? :each
      {}.tap do |out|
        hash.each_key { |key| out[key.to_s] = hash[key] }
      end
    end

    def parent_keys
      relationships = self.model.relationships
      [].tap do |keys|
        relationships.each do |relationship|
          keys << relationship.child_key.first.name
        end
      end
    end

    def excluded_hash_keys
      [:metadata, :markdown, :content, :path, :base_path]
    end
  end
end