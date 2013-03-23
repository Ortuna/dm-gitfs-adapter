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
    class Markdown
      include DataMapper::Gitfs::Resource
      resource_type :markdown
    end

    it 'should load its metadata' do
      a = Markdown.first
      p a
    end
  end
end