namespace :gitcopy do

  archive_name =  "archive.#{ DateTime.now.strftime('%Y%m%d%m%s') }.tar.gz" 

  # Deploy specific branch in the following way: 
  # $ cap deploy -s branch=<the branch you want to deploy>
  release_branch = ENV["branch"] || "master"

  desc "Archive files to #{archive_name}"
  file archive_name do |file| 
    system "git show --quiet #{fetch(:branch)}"
    if $?.exitstatus == 0
      system "git archive --format=tar #{fetch(:branch)} | gzip > #{ archive_name }"
    else
      puts "Can't find commit for: #{fetch(:branch)}"
    end
  end

  desc "Deploy #{archive_name} to release_path"
  task :deploy => archive_name do |file|
    tarball = file.prerequisites.first
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

    Rake::Task["gitcopy:clean"].invoke
  end

  task :clean do |t|
    # Delete the local archive
    File.delete archive_name if File.exists? archive_name
  end

  task :create_release => :deploy

  task :check

  task :set_current_revision

end
