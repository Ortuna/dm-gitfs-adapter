describe  DataMapper::Gitfs::Resource do
  
  class ExampleFile
    include DataMapper::Gitfs::Resource
    resource_type :file
  end

  it 'sets the correct resource type' do
    ExampleFile.resource_type.should == :file
  end

  describe 'queries' do
    it 'lists all the files in the tree' do
      ExampleFile.all.should_not be_nil
      ExampleFile.first.should_not be_nil
    end

    it 'should only return files in the tree' do
      ExampleFile.all.each do |ef|
        File.file?(ef.path).should == true
      end
    end
  end

end