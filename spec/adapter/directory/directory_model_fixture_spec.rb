describe 'DirectoryModel' do
  
  class DirectoryModel
    include DataMapper::Gitfs::Resource
    resource_type :directory
  end

  before :all do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
  end

  it 'loads correctly' do
    expect { directory = DirectoryModel.new }.not_to raise_error
  end

  it 'sets the resouce_type correctly' do
    DirectoryModel.resource_type.should == :directory
  end
end