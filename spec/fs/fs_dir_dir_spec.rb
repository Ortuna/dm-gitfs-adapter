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
  
  class NestedDir
    include DataMapper::Gitfs::Resource
    resource_type :directory
    has n, :directories, 'NestableDir'
  end

  class NestableDir
    include DataMapper::Gitfs::Resource
    resource_type :directory

    belongs_to :directory, 'NestedDir'
  end


  def create_directory_chain(dir1_name = 'dir1', dir2_name = 'dir2')
    dir              = NestedDir.new
    dir.base_path    = dir1_name
    dir.save

    dir2           = NestableDir.new
    dir2.base_path = dir2_name
    dir2.directory = dir
    dir2.save

    return dir, dir2
  end

  it 'saves correctly if there are subdirectories' do
    dir, dir2 = create_directory_chain('dir1', 'dir2')
    path      = "#{dir.send(:complete_path)}/#{dir2.base_path}"
    File.exists?(path).should == true
  end

  it 'saves normally if there isnt a parent' do
    dir              = NestedDir.new
    dir.base_path    = 'example path'
    dir.save

    File.exists?(dir.send(:complete_path)).should == true

    dir2           = NestableDir.new
    dir2.base_path = 'another path'
    dir2.save

    File.exists?(dir2.send(:complete_path)).should == true
  end

end