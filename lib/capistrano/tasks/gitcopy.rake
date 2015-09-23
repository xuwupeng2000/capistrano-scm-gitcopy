namespace :gitcopy do
  archive_name =  "archive.#{ DateTime.now.strftime('%Y%m%d%m%s') }.tar.gz"

  desc "Archive files to #{archive_name}"
  file archive_name do |file|
    no_repo_url = fetch(:repo_url) !~ /\S/

    local_git_dir = `git rev-parse --git-dir > /dev/null 2>&1`

    if no_repo_url && $?.exitstatus != 0
      raise 'Neither a remote repository has been given nor the current directory is a git repository. Aborting...'
    end

    matches = `git ls-remote #{no_repo_url ? local_git_dir : fetch(:repo_url)} | grep -P '^.{40}\t.*#{fetch(:branch)}$'`

    if matches.lines.count == 1
      puts "Making #{archive_name} archive..."
      system "git archive #{no_repo_url ? '' : "--remote #{fetch(:repo_url)}" } --format=tar #{fetch(:branch)}:#{fetch(:sub_directory)} | gzip > #{ archive_name }"
      set :current_revision, matches.lines.first.split("\t")[0]
    elsif matches.lines.count == 0
      puts "Can't find reference for: #{fetch(:branch)}"
    else
      puts "Multiple references found matching \"#{fetch(:branch)}\":"
      matches.lines.each do |line|
        puts "    #{line.split("\t")[1]}"
      end
      puts "Please set :branch variable with an exact reference (like #{matches.lines.first.split("\t")[1].chomp} instead of #{fetch(:branch)})."
    end
    # We stop here if we couldn't find a correct reference
    raise if matches.lines.count != 1
  end

  desc "Deploy #{archive_name} to release_path"
  task :deploy => archive_name do |file|
    tarball = file.prerequisites.first
    on roles :all do
      # Make sure the release directory exists
      execute :mkdir, '-p', release_path

      # Create a temporary file on the server
      tmp_file = execute :ruby, %Q(-rtempfile -e 'Tempfile.open("capistrano-") { |f| puts f.path }')

      # Upload the archive, extract it and finally remove the tmp_file
      upload! tarball, tmp_file
      execute :tar, '-xzf', tmp_file, '-C', release_path
      execute :rm, tmp_file
    end
  end

  task :clean do |t|
    # Delete the local archive
    File.delete archive_name if File.exists? archive_name
  end
  after 'deploy:finished', 'gitcopy:clean'

  task :create_release => :deploy

  task :check

  task :set_current_revision
end
