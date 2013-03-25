module DataMapper
  module Gitfs
    module Model
      module Markdown
        def self.included(model)
          model.property :metadata, Class
          model.property :markdown, String
        end
      end
    end
  end
end