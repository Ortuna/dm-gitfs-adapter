describe DataMapper::Gitfs do
  before :each do
    @tmp_path = File.expand_path('/tmp/git_history')
    FileUtils.mkdir(@tmp_path) unless File.exists?(@tmp_path)
    DataMapper.setup(:gitfs, "gitfs:://#{@tmp_path}")
  end

  after :each do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
    FileUtils.rm_rf @tmp_path
  end

  class FileResourceGit
    include DataMapper::Gitfs::Resource
    resource_type :file
  end
  
  def create_resource(resource_path, content)
    file = FileResourceGit.new
    file.base_path = resource_path
    file.content   = content
    file.save
    file
  end


  it 'has a repo variable' do
    file = create_resource('repo_test.txt', 'abz')
    file.repo.should_not be_nil

  end

  it 'creats a commit for each change' do
    file = create_resource('example_file.txt', 'xyz')
    file.save

    file.repo.log.count.should == 1

    file = FileResourceGit.first(:base_path => 'example_file.txt')
    file.base_path = 'name_change.txt'
    file.content   = 'new content'
    file.save
    
    file.repo.log.count.should == 2
  end

  it 'should delete old files from the index'
end