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
    FileResource.new.tap do |file|
      file.base_path = resource_path
      file.content   = content
      file.save
    end
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

  it 'adds a new line to the end' do
    base_path = "example_file_with_content.txt"
    file      = create_resource(base_path, 'some content here')
    file.content.should == "some content here\n"
  end

  it 'strips multiple new lines' do
    base_path = "example_file_with_content.txt"
    file      = create_resource(base_path, "some content here\n\n\n")
    file.content.should == "some content here\n"
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

  it 'doesnt allow renaming to already existing file' do
    org_content   = 'some content here'
    resource_path = 'file 1.md'

    create_resource(resource_path, org_content)
    create_resource("#{resource_path}_new", org_content)

    file = FileResource.first(:base_path => "#{resource_path}_new")
    file.base_path = resource_path
    file.save.should == false
  end

  it 'doesnt allow creating an already existing file' do
    create_resource('file 1.md', 'content')
    create_resource('file 1.md', 'junk')

    file = FileResource.first(:base_path => "file 1.md")
    file.content.should == "content\n"
  end

  it 'saves changed content' do
    base_path    = "fantastic_old_path.txt"
    create_resource(base_path, 'some content here')

    file = find_resource(base_path)
    file.content = "new content"
    file.save

    file = find_resource(base_path)
    file.content.should == "new content\n"
  end

  it 'all together' do
    base_path      = "file_org.txt"
    file           = create_resource(base_path, 'some content here')

    file.content   = "Changed Content"
    file.base_path = "changed_path.txt"
    file.save

    file = find_resource("changed_path.txt")
    file.content.should   == "Changed Content\n"
    file.base_path.should == "changed_path.txt"
  end
end