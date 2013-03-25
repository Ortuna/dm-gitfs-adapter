describe DataMapper::Gitfs::Model::Markdown do
  before :each do
    @tmp_path = File.expand_path('/tmp/git_markdown_specs')  
    FileUtils.mkdir(@tmp_path) unless File.exists?(@tmp_path)
    DataMapper.setup(:gitfs, "gitfs:://#{@tmp_path}")
  end

  after :each do
    DataMapper.setup(:gitfs, "gitfs:://#{SPEC_PATH}/fixtures/sample_tree")
    FileUtils.rm_rf @tmp_path
  end

  class MarkdownResource
    include DataMapper::Gitfs::Resource
    resource_type :markdown
  end

  class MarkdownResourceWithProperty
    include DataMapper::Gitfs::Resource
    resource_type :markdown
    property :time_dot_now, Class
  end

  def default_metadata
    {
      'title'   => 'example title',
      'author'  => 'example author'
    }
  end

  def find_resource(base_path)
    MarkdownResource.first(:base_path => base_path)
  end

  def create_resource(resource_path, metadata = default_metadata, markdown = '#md')
    MarkdownResource.new.tap do |md|
      md.base_path = resource_path
      md.metadata  = metadata
      md.markdown  = markdown
      md.save
    end
  end

  it 'saves markdown to a file' do
    create_resource('md_test.md', {'author' => 'poe'}, '#this is md')
    File.exists?("#{@tmp_path}/md_test.md").should == true
  end

  it 'saves metadata to the file' do
    metadata = {'author' => 'poe'} 
    path     = 'md_test.md'
    create_resource(path, metadata, nil)
    md = find_resource(path)
    md.metadata['author'].should == 'poe'
  end

  it 'saves the markdown to the file' do
    metadata = nil
    path     = 'md_test_markdown.md'
    create_resource(path, nil, '#example markdown')

    md = find_resource(path)
    md.markdown.should == '#example markdown'
  end

  it 'saves both metadata and markdown together' do
    create_resource('md_test.md', {'author' => 'poe'}, '#this is md')
    md = find_resource('md_test.md')
    md.metadata['author'].should == 'poe'
    md.markdown.should == '#this is md'
  end

  it 'saves loose fields to metadata' do
    time_dot_now = Time.now
    mdwp = MarkdownResourceWithProperty.new
    mdwp.base_path     = 'md_with_property.md'
    mdwp.time_dot_now  = time_dot_now
    mdwp.save

    mdwp = MarkdownResourceWithProperty.first(:base_path => 'md_with_property.md')
    mdwp.time_dot_now.should == time_dot_now
  end

end