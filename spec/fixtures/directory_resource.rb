DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")

class DirectoryListerConfig
  include DataMapper::Gitfs::Resource
  resource_type :directory
  property      :title, String
  attr_accessor :dont_set
end

class DirectoryLister
  include DataMapper::Gitfs::Resource
  resource_type :directory
end

class PathExample
  include DataMapper::Gitfs::Resource
  resource_type :directory
end


class ExampleSomethingTwo
  include DataMapper::Gitfs::Resource
  resource_type :directory
end

class ExampleDirectory
  include DataMapper::Gitfs::Resource
  resource_type :directory
end