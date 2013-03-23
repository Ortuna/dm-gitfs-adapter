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
  describe 'protected fields' do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
    class ROExample
      include DataMapper::Gitfs::Resource
      resource_type :directory
    end

    it 'should not allow setting of read-only fields' do
      item = ROExample.first
      expect {
        item.path = "its late"
      }.to raise_error

      expect {
        item.base_path = "zyx abc"
      }.to raise_error      
    end
  end

  describe 'hooks' do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
    class HooksExample
      include DataMapper::Gitfs::Resource
      resource_type :directory

      def after_load
        raise 'FailHere'
      end
    end

    it 'should call after_load on the model' do
      expect {
        a = HooksExample.first
      }.to raise_error
    end
  end
end