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
  
  class DirResourceGit
    include DataMapper::Gitfs::Resource
    resource_type :directory
  end

  def create_file(resource_path, content)
    file = FileResourceGit.new
    file.base_path = resource_path
    file.content   = content
    file.save
    file
  end

  def create_directory(resource_path)
    directory = DirResourceGit.new
    directory.base_path = resource_path
    directory.save
    directory
  end

  it 'has a repo variable' do
    file = create_file('repo_test.txt', 'abz')
    file.repo.should_not be_nil

  end

  it 'creates a commit for each change' do
    file = create_file('example_file.txt', 'xyz')

    file.repo.log.count.should == 1

    file = FileResourceGit.first(:base_path => 'example_file.txt')
    file.base_path = 'name_change.txt'
    file.content   = 'new content'
    file.save
    
    file.repo.log.count.should == 2
  end

  it 'accepts directories in its path' do
    file           = create_file('example_file.txt', 'xyz')
    original_path  = file.send(:complete_path)

    file = FileResourceGit.first(:base_path => 'example_file.txt')
    file.base_path = 'xyz/test.txt'
    file.save

    File.exists?(original_path).should == false
    File.exists?(file.send(:complete_path)).should == true
  end

  it 'has a repo variable' do
    directory = create_directory('new_directory')
    directory.repo.should_not be_nil
  end

  it 'create a commit for each change' do
    directory     = create_directory('changeable')
    original_path = directory.send(:complete_path)


    directory = DirResourceGit.first(:base_path => 'changeable')
    directory.base_path = 'zztop'
    directory.save

    directory.repo.log.count.should == 2

    File.exists?(original_path).should == false
    File.exists?(directory.send(:complete_path)).should == true
  end

end