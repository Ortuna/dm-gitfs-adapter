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
    end 

    class MdWithAutoVariables
      include DataMapper::Gitfs::Resource
      resource_type :markdown
    end

    it 'should load its metadata' do
      md = Md.first
      md.metadata["title"].should == 'Section 1'
    end

    it 'sets markdown property if present' do
      md = MdWithAutoVariables.first
      md.markdown.should_not be_nil
    end

    it 'sets metadata property if present' do
      md = MdWithAutoVariables.first
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