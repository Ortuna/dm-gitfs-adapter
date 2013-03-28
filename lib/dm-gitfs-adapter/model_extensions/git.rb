module DataMapper::Gitfs::Model
  module Git
    def git_update_tree(message)
      pwd = Dir.pwd
      Dir.chdir repository.adapter.path
      repo.git.add({}, '-Av', '.')
      repo.commit_index message
      Dir.chdir pwd
    end
  end
end