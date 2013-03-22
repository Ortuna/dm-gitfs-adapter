require 'dm-core'
require 'grit'

require 'dm-gitfs-adapter/version'
require 'dm-gitfs-adapter/adapter'

DataMapper::Adapters::GitfsAdapter = DataMapper::Gitfs::Adapter