class Directory
  include DataMapper::Gitfs::Resource
  resource_type :directory

  has n, :markdowns, 'Markdown'
end

class Markdown
  include DataMapper::Gitfs::Resource
  resource_type :markdown

  belongs_to :directory, 'Directory'
end