describe DataMapper::Gitfs do
  
  before :each do
    @tmp_path = File.expand_path('/tmp/git_dir_file_spec')
    FileUtils.mkdir(@tmp_path) unless File.exists?(@tmp_path)
    DataMapper.setup(:gitfs, "gitfs:://#{@tmp_path}")
  end

  after :each do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
    FileUtils.rm_rf @tmp_path
  end

  class RFile
    include DataMapper::Gitfs::Resource
    resource_type :markdown
    belongs_to    :directory, 'RDir'
  end
  
  class RDir
    include DataMapper::Gitfs::Resource
    resource_type :directory
    has n,        :files, 'RFile'
  end

  def create_file_directory(file_name = 'temp.txt', directory_name = 'temp')
    dir            = RDir.new
    dir.base_path  = directory_name
    dir.save

    file           = RFile.new
    file.base_path = file_name
    file.directory = dir
    file.save

    return file, dir
  end

  it 'saves inside parent directory model' do
    file, dir = create_file_directory 'new.txt', 'new'
    file.base_path.should == RDir.first.files.first.base_path
  end

  it 'moves its children with a rename' do
    file, dir      = create_file_directory
    original_path  = dir.send(:complete_path)
    dir            = RDir.first(:base_path => 'temp')
    dir.base_path  = 'real_path'
    dir.save

    new_path = dir.send(:complete_path)
    File.exists?(original_path).should == false
    File.exists?("#{original_path}/#{file.base_path}").should == false

    File.exists?(new_path).should == true
    File.exists?("#{new_path}/#{file.base_path}").should == true
  end

  it 'doesnt delete if has children' do
    file, dir = create_file_directory 'should_not_delete.txt', 'safe_dir'
    dir_path  = dir.send(:complete_path)
    file_path = file.send(:complete_path)

    File.exists?(dir_path).should  == true
    File.exists?(file_path).should == true

    dir.destroy
    
    File.exists?(dir_path).should  == true
    File.exists?(file_path).should == true
  end

  it 'deletes if it doesnt have children' do
    file, dir = create_file_directory 'should_not_delete2.txt', 'safe_dir2'
    dir_path  = dir.send(:complete_path)
    file_path = file.send(:complete_path)

    File.exists?(dir_path).should  == true
    File.exists?(file_path).should == true

    file.destroy
    dir.destroy

    File.exists?(file_path).should == false
    File.exists?(dir_path).should  == false
  end

  it 'allows destroy with bang' do
    file, dir = create_file_directory 'should_not_delete2.txt', 'safe_dir2'
    dir_path  = dir.send(:complete_path)

    dir.destroy!
    File.exists?(dir_path).should  == false
  end

  it 'doesnt complain about unloaded relationship' do
    file, dir = create_file_directory 'saveable.txt', 'saveable'
    file = RFile.first
    expect {
      file.directory
      file.save
    }.to_not raise_error
    
  end
end