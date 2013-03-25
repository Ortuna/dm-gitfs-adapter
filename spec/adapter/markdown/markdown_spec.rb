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

    class MdWithAutoVariables
      include DataMapper::Gitfs::Resource
      resource_type :markdown
      apply_markdown_properties
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

    it 'sets metadata and markdown properties with #markdown_properties' do
      md = MdWithAutoVariables.first
      md.metadata.should_not be_nil
      md.markdown.should_not be_nil

      md.metadata["title"].should == "Section 1"
    end

    it 'should not complain if there isnt any markdown' do
      expect {
        md = Md.all(:base_path => "folder2_file.md")
      }.not_to raise_error
    end
  end

  describe 'metadata' do
    class MdMetadata
      include DataMapper::Gitfs::Resource
      resource_type :markdown
      apply_markdown_properties

      property :author, String
    end

    it 'sets properties that in metadata' do
      md = MdMetadata.first
      md.author.should_not be_nil
    end

    it 'doesnt complain if there isnt any markdown' do
      expect {
        md = MdMetadata.all(:base_path => "folder2_file.md")
      }.not_to raise_error
    end
  end
end