require 'dm-core'
require 'grit'

require 'dm-gitfs-adapter/version'

#Mixins for the adapater read/save etc
require 'dm-gitfs-adapter/adapter_extensions/markdown'
require 'dm-gitfs-adapter/adapter_extensions/directory'
require 'dm-gitfs-adapter/adapter_extensions/file'

#Mixins for the models e.g. model_instance.xyz
require 'dm-gitfs-adapter/model_extensions/markdown'

require 'dm-gitfs-adapter/git/git'
require 'dm-gitfs-adapter/adapter'
require 'dm-gitfs-adapter/resource'


DataMapper::Adapters::GitfsAdapter = DataMapper::Gitfs::Adapter