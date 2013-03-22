require 'dm-core'
require 'grit'

require 'dm-gitfs-adapter/version'
require 'dm-gitfs-adapter/resource_types/directory'
require 'dm-gitfs-adapter/resource_types/file'
require 'dm-gitfs-adapter/adapter'
require 'dm-gitfs-adapter/resource'

DataMapper::Adapters::GitfsAdapter = DataMapper::Gitfs::Adapter