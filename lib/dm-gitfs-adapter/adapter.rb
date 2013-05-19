module DataMapper
  module Gitfs
    class Adapter < DataMapper::Adapters::AbstractAdapter

      include DataMapper::Gitfs::Markdown
      include DataMapper::Gitfs::Directory
      include DataMapper::Gitfs::File

      attr_reader   :path, :remote_path, :remote_push
      attr_accessor :repo

      def initialize(name, options)
        super
        @path        = make_path(options["path"])
        @remote_path = options["query"]

        @remote_path ? clone_repo(@remote_path, @path) : verify_path_exists!(@path)
        @remote_push = is_remote_repo? options["fragment"]
        @repo        = find_or_create_repo!(@path)
      end

      def read(query)
        records = send("read_#{query.model.resource_type}", query)
        query.filter_records(records)
      end

      private
      def is_remote_repo?(fragment)
        if (fragment && fragment.downcase == 'local-only')
          @remote_push = false
        else
          @remote_push = true
        end
      end

      def find_or_create_repo!(path)
        Grit::Repo.new(path)
      rescue
        Grit::Repo.init(path)
      end

      def verify_path_exists!(path)
        raise "Path not found" unless ::File.exists?(path)
      end

      def clone_repo(remote_path, local_path)
        gritty = Grit::Git.new(local_path)
        gritty.clone({}, remote_path, local_path)
        raise 'Could not clone' if Grit::Repo.new(local_path).git.list_remotes.empty?
      end

      def has_remotes?(repo)
        
      end

      def make_path(path)
        path.sub('://', '')
      end

      def apply_config(record, options)
        return unless options.respond_to? :each
        options.each do |option, value|
          if record.respond_to? "#{option}="
            record.public_send("#{option}=".to_sym, value)
          end
        end
      end

      def extract_query_params(query)
        return {} unless conditions = query.options[:conditions]
        conditions.each do |options, parent_model|
          next if parent_model.respond_to? :each
          next unless defined?(parent_model.class.resource_type)
          next unless parent_model.class.resource_type == :directory
          return { :root_path => extract_root_path(parent_model),
                   :path_key  => extract_root_key_name(options) }
        end
      end

      def extract_root_key_name(options)
        options.child_key.first.name
      end

      def extract_root_path(parent_model)
        parent_model.path
      end

    end #class Adapter
  end #module Gitfs
end #module DataMapper