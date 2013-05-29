[![Build Status](https://travis-ci.org/Ortuna/dm-gitfs-adapter.png?branch=master)](https://travis-ci.org/Ortuna/dm-gitfs-adapter)
[![Code Climate](https://codeclimate.com/github/Ortuna/dm-gitfs-adapter.png)](https://codeclimate.com/github/Ortuna/dm-gitfs-adapter)
## Installation

    gem 'dm-gitfs-adapter'
    $ bundle


## Usage

```ruby
DataMapper.setup(:gitfs, "gitfs:://path/to/directory/tree")

class Directory
  include DataMapper::Gitfs::Resource
  resource_type :directory

  has n, :markdowns, 'Markdown'
end

class Markdown
  include DataMapper::Gitfs::Resource
  resource_type :markdown

  belongs_to :directory, 'Directory'
end

Directory.all # => List of directories in the repo path
Directory.first.markdowns #=> list of markdown files in the first directory
```
