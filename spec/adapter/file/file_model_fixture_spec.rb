describe FileModel do

  before :all do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
  end

  it 'loads correctly' do
    expect { directory = FileModel.new }.not_to raise_error
  end

  it 'sets the resouce_type correctly' do
    FileModel.resource_type.should == :file
  end
end