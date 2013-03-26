describe DataMapper::Gitfs do
  before :each do
    @tmp_path = File.expand_path('/tmp/git_relationship_history')
    FileUtils.mkdir(@tmp_path) unless File.exists?(@tmp_path)
    DataMapper.setup(:gitfs, "gitfs:://#{@tmp_path}")
  end

  after :each do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
    File
  end
end