describe DataMapper::Gitfs do
  
  before :each do
    @tmp_path = File.expand_path('/tmp/git_history')
    FileUtils.mkdir(@tmp_path) unless File.exists?(@tmp_path)
    DataMapper.setup(:gitfs, "gitfs:://#{@tmp_path}")
  end

  after :each do
    @fixture_path = "#{SPEC_PATH}/fixtures/sample_tree"
    DataMapper.setup(:gitfs, "gitfs:://#{@fixture_path}")
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
    FileResourceGit.new.tap do |file|
      file.base_path = resource_path
      file.content   = content
      file.save
    end
  end

  def create_directory(resource_path)
    DirResourceGit.new.tap do |directory|
      directory.base_path = resource_path
      directory.save
    end
  end

  describe 'save and change #file' do

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

  end

  describe 'save and change #directory' do
    
    it 'has a repo variable' do
      directory = create_directory('new_directory')
      directory.repo.should_not be_nil
    end

    it 'create a commit for each change' do
      directory     = create_directory('changeable')
      original_path = directory.send(:complete_path)


      directory = DirResourceGit.first(:base_path => 'changeable')
      directory.base_path = 'saveable'
      directory.save

      directory.repo.log.count.should == 2

      File.exists?(original_path).should == false
      File.exists?(directory.send(:complete_path)).should == true
    end

  end

  describe 'destroy #file' do
    
    it 'commits a delete to the repo' do
      file = create_file('new_file.txt', 'content')
      original_path = file.send(:complete_path)

      file.destroy
      repo = Grit::Repo.new(File.dirname(original_path))
      repo.log.count.should == 2      
    end

  end

  describe 'destroy #directory' do
    
    it 'commits a delete to the repo' do
      directory     = create_directory('changeable')
      original_path = directory.send(:complete_path)
      directory.destroy

      repo = Grit::Repo.new(File.dirname(original_path))
      repo.log.count.should == 2
    end

  end

  describe 'remote repos', :remote => true do

    before :each do
      # @remote_repo = "git@github.com:Ortuna/blog.git"
      @new_path    = "#{@tmp_path}_remote"
      @remote_repo = "#{SPEC_PATH}/fixtures/sample_tree"

      FileUtils.cp_r(@remote_repo, "#{@new_path}_source")
      DataMapper.setup(:gitfs, "gitfs:://#{@new_path}?#{@remote_repo}")
    end

    after :each do
      FileUtils.rm_rf @new_path
      FileUtils.rm_rf "#{@new_path}_source"
    end

    it 'pulls in a remote repo' do
      DirResourceGit.all.should_not      be_empty
      DirResourceGit.repo.log.should_not be_empty
      File.exists?(@new_path).should == true
    end

    it 'pushes to the remote repo' do
      dir = DirResourceGit.first
      dir.base_path = 'new_path'
      dir.save

      FileUtils.rm_rf @new_path
      DataMapper.setup(:gitfs, "gitfs:://#{@new_path}?#{@new_path}_source")

      DirResourceGit.first(:base_path => 'new_path').should_not be_nil
    end

  end
end