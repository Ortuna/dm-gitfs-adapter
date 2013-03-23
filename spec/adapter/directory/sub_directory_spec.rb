describe 'Multiple levels directories' do

  describe 'recursive relationship' do
    class Directory
      include DataMapper::Gitfs::Resource
      resource_type :directory
      property      :title, String
      has n,        :directories, 'Directory'
    end

    it 'retrieves directories that are nested' do
      directory    = Directory.first
      subdirectory = directory.directories.first
      subdirectory.should_not be_nil
      subdirectory.title.should == 'subdirectoryz'
    end
  end

  describe 'linear relationship' do
    class Parent
      include DataMapper::Gitfs::Resource
      resource_type :directory
      has n,        :subs
    end

    class Sub
      include DataMapper::Gitfs::Resource
      resource_type :directory
      property   :title, String
      belongs_to :parent
    end

    it 'retrieves directories that are nested' do
      parent = Parent.first
      sub    = parent.subs.first
      sub.title.should == 'subdirectoryz'
    end
  end
end