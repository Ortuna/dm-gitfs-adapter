describe DataMapper::Gitfs::Markdown do
  it 'should recognize markdown as a type' do
    expect {
      class MarkdownDetect
        include DataMapper::Gitfs::Resource
        resource_type :markdown
      end
    }.not_to raise_error
  end

  describe 'loader' do
    class Md
      include DataMapper::Gitfs::Resource
      resource_type :markdown

      property :metadata, Class
      property :markdown, String
    end

    class MdWithoutMetaData
      include DataMapper::Gitfs::Resource
      resource_type :markdown

      property :markdown, String
    end

    class MdWithoutMarkdown
      include DataMapper::Gitfs::Resource
      resource_type :markdown

      property :metadata, Class
    end 

    it 'should load its metadata' do
      md = Md.first
      md.metadata["title"].should == 'Section 1'
    end

    it 'doesnt set a metadata property if not present' do
      md = MdWithoutMetaData.first
      expect {
        md.metadata
      }.to raise_error(NoMethodError)
    end

    it 'doesnt set a markdown property if not present' do
      md = MdWithoutMarkdown.first
      expect {
        md.markdown
      }.to raise_error(NoMethodError)
    end

    it 'sets markdown property if present' do
      md = MdWithoutMetaData.first
      md.markdown.should_not be_nil
    end

    it 'sets metadata property if present' do
      md = MdWithoutMarkdown.first
      md.metadata.should_not be_nil
    end
  end
end