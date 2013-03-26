describe DataMapper::Gitfs::Model::Directory do
  before :each do
    @tmp_path = File.expand_path('/tmp/git_directory_specs')
    FileUtils.mkdir(@tmp_path) unless File.exists?(@tmp_path)
    DataMapper.setup(:gitfs, "gitfs:://#{@tmp_path}")
  end

  after :each do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
    FileUtils.rm_rf @tmp_path
  end

  class DirectoryResource
    include DataMapper::Gitfs::Resource
    resource_type :directory
  end

  def find_resource(base_path)
    DirectoryResource.first(:base_path => base_path)
  end

  def create_resource(resource_path)
    DirectoryResource.new.tap do |d|
      d.base_path = resource_path
      d.save
    end
  end

  it 'saves the directory resource' do
    base_path = 'folder1'
    create_resource(base_path)

    dir = find_resource(base_path)
    dir.base_path.should == base_path

    File.directory?(dir.path).should == true
  end

  it 'renames existing directory' do
    base_path = 'folder2'
    create_resource(base_path)

    dir = find_resource(base_path)
    dir.base_path.should == 'folder2'

    dir.base_path = 'folder1'
    dir.save

    dir = find_resource('folder1')
    dir.base_path.should == 'folder1'
  end

  it 'should delete empty directories' do
    directory     = create_resource('folderz')
    complete_path = directory.send(:complete_path)

    directory.destroy
    File.exists?(complete_path).should == false
  end

  it 'should not delete occupied directory' do
    directory     = create_resource('folderz')
    complete_path = directory.send(:complete_path)

    FileUtils.touch "#{complete_path}/example_file.zip"

    directory.destroy
    File.exists?(complete_path).should == true
    File.exists?("#{complete_path}/example_file.zip").should == true    
  end
end