describe DataMapper::Gitfs::Adapter do
  describe 'adapter setup' do
    it 'Should find the adapter' do
      expect {
        DataMapper.setup(:default, 'gitfs:://sample_book') 
      }.not_to raise_error
    end
  end
end