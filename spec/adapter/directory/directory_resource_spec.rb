describe  DataMapper::Gitfs::Resource do

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


  it 'errors on incorrect resource type' do
    expect {
      class ExampleSomething
        include DataMapper::Gitfs::Resource
        resource_type :abcxyz
      end
    }.to raise_error
  end

  it 'has the correct resource type' do
    ExampleSomethingTwo.resource_type.should == :directory
  end

  it 'added the root path of the adapter to all models' do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
    PathExample.repository_path.should == "#{SPEC_PATH}/fixtures/sample_tree"
  end

  describe 'queries' do
    it 'lists all the directories in the tree' do
      DirectoryLister.all.should_not be_nil
      DirectoryLister.first.should_not be_nil
    end

    it 'adds the default path property' do
      DirectoryLister.first[:path].should_not be_empty
    end
  end

  describe 'config' do
    it 'sets the property from configs' do
      entry = DirectoryListerConfig.first
      entry.title.should == 'example title'
    end

  end
end