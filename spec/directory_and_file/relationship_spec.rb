describe 'relationship' do
  class ExampleDirectory
    include DataMapper::Gitfs::Resource
    resource_type :directory
    property      :title, String

    has n, :files, ExampleFile
    has n, :directories, self
  end

  class ExampleFile
    include DataMapper::Gitfs::Resource
    resource_type :file

    belongs_to :directory,   ExampleDirectory
  end

  it 'finds all files under a directory' do
    directory = ExampleDirectory.first(:title => 'example title')
    files     = directory.files.all
    files.first.path.should_not be_empty
  end

  it 'should still find all files' do
    files = ExampleFile.all
    files.count.should >= 2
  end

  it 'finds its subdirectories' do
    directory = ExampleDirectory.first
    # p directory.directories
    # directory.directories.should_not be_empty
  end
end