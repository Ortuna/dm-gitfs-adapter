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

  class DirectoryWithProperty
    include DataMapper::Gitfs::Resource
    resource_type :directory

    property :axis, String
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

  it 'doesnt allow renaming to existing directory' do
    create_resource('dir 1')
    create_resource('dir 2')
    dir = find_resource('dir 2')
    dir.base_path = 'dir 1'
    dir.save.should == false
  end

  it 'doesnt create already existing directory' do
    create_resource('dir 1')
    d = DirectoryResource.new
    d.base_path = 'dir 1'
    d.save.should == false
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

  it 'should delete occupied directory with bang' do
    directory     = create_resource('folderz')
    complete_path = directory.send(:complete_path)

    FileUtils.touch "#{complete_path}/example_file.zip"

    directory.destroy!
    File.exists?(complete_path).should == false
    File.exists?("#{complete_path}/example_file.zip").should == false
  end

  it 'should write a config on save' do
    directory = DirectoryWithProperty.new()
    directory.axis      = 'exceptional string'
    directory.base_path = 'dir_with_config'
    directory.save
    
    directory_path = directory.send(:complete_path)
    config_file    = "#{directory_path}/_config.yml"

    File.exists?(config_file).should == true    
  end

  it 'saves extra properties' do
    directory = DirectoryWithProperty.new()
    directory.axis      = 'exceptional string'
    directory.base_path = 'dir_with_property'
    directory.save

    directory = DirectoryWithProperty.first
    directory.axis.should == 'exceptional string'
  end
  
end