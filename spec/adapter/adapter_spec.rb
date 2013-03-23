describe DataMapper::Gitfs::Adapter do

  it 'finds the adapter' do
    expect {
      DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree") 
    }.not_to raise_error
  end

  it 'raises errors on unkown directories' do
    expect {
      DataMapper.setup(:gitfs, 'gitfs:://fixtures/unkown_tree') 
    }.to raise_error
  end
end