namespace :gitcopy do

  archive_name = "archive.tar.gz"
  include_dir  = fetch(:include_dir) || "*"
  exclude_dir  = fetch(:exclude_dir) || ""

  # Deploy specific branch in the following way: 
  # $ cap deploy -s branch=<the branch you want to deploy>
  release_branch = ENV["branch"] || "master"

  desc "Archive files to #{archive_name}"
  task :tar_release_branch do 
    run_locally do
      execute "mkdir -p ~/tmp"
      temporary_folder_name = execute "mktemp -u" 
      execute "git clone #{fetch(:repo_url)} --branch #{release_branch} --single-branch ~/#{temporary_folder_name.to_s}"
      execute "cd ~/tmp/temporary_folder_name"

      file archive_name => FileList[include_dir].exclude(archive_name) do |t|
        execute "tar -cvzf #{t.name} #{t.prerequisites.join(" ")}" + (exclude_dir.empty? ? "" : " --exclude #{exclude_dir}")
      end
    end
  end

  desc "Deploy #{archive_name} to release_path"
  task :deploy => archive_name do |t|
    tarball = t.prerequisites.first
    on roles :all do

      # Make sure the release directory exists
      execute :mkdir, "-p", release_path

      # Create a temporary file on the server
      tmp_file = capture("mktemp")

      # Upload the archive, extract it and finally remove the tmp_file
      upload!(tarball, tmp_file)
      execute :tar, "-xzf", tmp_file, "-C", release_path
      execute :rm, tmp_file
    end

    Rake::Task["copy:clean"].invoke
  end

  task :clean do |t|
    # Delete the local archive
    File.delete archive_name if File.exists? archive_name
  end

  task :create_release => :deploy

  task :check

  task :set_current_revision

end
