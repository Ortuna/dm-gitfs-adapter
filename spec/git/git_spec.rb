describe DataMapper::Gitfs::Git do
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

  it 'creates a log of changes' do
    file = create_resource('example_file.txts', 'xyz')
    file.save
  end
end