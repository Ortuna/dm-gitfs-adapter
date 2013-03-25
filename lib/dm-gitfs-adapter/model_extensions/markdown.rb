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
      """ #{Gitfshelper.hash_to_yaml(metadata)}
      ----------
      """
    end

    def markdown_for_content
      markdown || ""
    end
  end
end