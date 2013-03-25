describe DataMapper::Gitfs::Model::File do
  before :each do
    @tmp_path = File.expand_path('/tmp/git_fs_specs')  
    FileUtils.mkdir(@tmp_path) unless File.exists?(@tmp_path)
    DataMapper.setup(:gitfs, "gitfs:://#{@tmp_path}")
  end

  after :each do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
    FileUtils.rm_rf @tmp_path
  end

  class FileResource
    include DataMapper::Gitfs::Resource
    resource_type :file
  end

  def create_resource(resource_path, content)
    file = FileResource.new
    file.base_path = resource_path
    file.content   = content
    file.save
    file
  end

  def find_resource(base_path)
    FileResource.first(:base_path => base_path)
  end

  it 'saves a new file' do
    create_resource("example_file.txt", 'some content here')
    file = find_resource("example_file.txt")
    file.should_not be_nil

    File.exists?("#{@tmp_path}/example_file.txt").should == true
  end

  it 'deletes a file once destroyed' do
    file = create_resource("example_file.txt", 'some content here')
    File.exists?("#{@tmp_path}/example_file.txt").should == true
    file.destroy
    File.exists?("#{@tmp_path}/example_file.txt").should == false
  end

  it 'saves the contents of the model to the file' do
    base_path = "example_file_with_content.txt"
    file      = create_resource(base_path, 'some content here')
    file.content.should == "some content here"
  end

  it 'renames if path has changed' do
    base_path    = "fantastic_old_path.txt"
    file = create_resource(base_path, 'some content here')

    new_base_path = "fantastic_new_path.txt"
    file = find_resource(base_path)
    file.base_path  = new_base_path
    file.save

    File.exists?("#{@tmp_path}/#{base_path}").should     == false
    File.exists?("#{@tmp_path}/#{new_base_path}").should == true

  end

  it 'saves changed content' do
    base_path    = "fantastic_old_path.txt"
    create_resource(base_path, 'some content here')

    file = find_resource(base_path)
    file.content = "new content"
    file.save

    file = find_resource(base_path)
    file.content.should == "new content"    
  end

  it 'all together' do
    base_path    = "file_org.txt"
    file           = create_resource(base_path, 'some content here')

    file.content   = "Changed Content"
    file.base_path = "changed_path.txt"
    file.save

    file = find_resource("changed_path.txt")
    file.content.should   == "Changed Content"
    file.base_path.should == "changed_path.txt"
  end
end