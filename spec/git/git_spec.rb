describe DataMapper::Gitfs::Git do
  class GitfsIncluded
    include DataMapper::Gitfs::Resource
    resource_type :markdown
  end

  it 'should include the git mixin' do
    gitfs = GitfsIncluded.new
    gitfs.respond_to?(:inst_method).should == true
  end
end