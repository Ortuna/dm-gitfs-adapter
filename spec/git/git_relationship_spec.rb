describe DataMapper::Gitfs do
  before :each do
    @tmp_path = File.expand_path('/tmp/git_relationship_history')
    FileUtils.mkdir(@tmp_path) unless File.exists?(@tmp_path)
    DataMapper.setup(:gitfs, "gitfs:://#{@tmp_path}")
  end

  after :each do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
    FileUtils.rm_rf @tmp_path
  end

  class RFile
    include DataMapper::Gitfs::Resource
    resource_type :file
    belongs_to    :directory, 'RDir'
  end
  
  class RDir
    include DataMapper::Gitfs::Resource
    resource_type :directory
    has n,        :files, 'RFile'
  end

  it 'should save inside parent directory model' do
    file = RFile.new
    file.base_path = 'subfile.txt'

    dir = RDir.new
    dir.base_path = 'xyz'
    dir.save
    
    file.directory = dir
    file.save

    file.base_path.should == RDir.first.files.first.base_path
  end

  it 'should move its children with a rename' do
    dir = RDir.new
    dir.base_path = 'temp'
    dir.save

    file = RFile.new
    file.base_path = 'temp.txt'
    file.directory = dir
    file.save

    original_path = dir.send(:complete_path)
    dir = RDir.first(:base_path => 'temp')
    dir.base_path = 'real_path'
    dir.save

    new_path = dir.send(:complete_path)
    File.exists?(original_path).should == false
    File.exists?("#{original_path}/#{file.base_path}").should == false

    File.exists?(new_path).should == true
    File.exists?("#{new_path}/#{file.base_path}").should == true
  end

end