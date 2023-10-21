strategy = self

namespace :gitcopy do

  set :git_environmental_variables, ->() {
    {
      git_askpass: "/bin/echo",
      git_ssh:     "#{fetch(:tmp_dir)}/#{fetch(:application)}/git-ssh.sh"
    }
  }

  desc 'Generate the git wrapper script, this script guarantees that we can script git without getting an interactive prompt'
  task :wrapper do
    run_locally do
      execute :mkdir, "-p", "#{fetch(:tmp_dir)}/#{fetch(:application)}/"

      File.open("#{fetch(:tmp_dir)}/#{fetch(:application)}/git-ssh.sh", "w") do |file|
        file.write ("#!/bin/sh -e\nexec /usr/bin/ssh -o PasswordAuthentication=no -o StrictHostKeyChecking=no \"$@\"\n")
      end

      execute :chmod, "+x", "#{fetch(:tmp_dir)}/#{fetch(:application)}/git-ssh.sh"
    end
  end

  desc 'Check that the repository is reachable'
  task :check => :'gitcopy:wrapper' do
    run_locally do
      with fetch(:git_environmental_variables) do
        strategy.check
      end
    end
  end

  desc 'Clone the repo to the cache'
  task :clone => :'gitcopy:wrapper' do
    local_path = fetch(:local_path)

    run_locally do
      execute :mkdir, '-p', local_path

      within local_path do
        with fetch(:git_environmental_variables) do
          strategy.clone
        end
      end
    end
  end

  desc 'Update the repo mirror to reflect the origin state'
  task :update => :'gitcopy:clone' do
    local_path = fetch(:local_path)

    run_locally do
      within local_path do
        with fetch(:git_environmental_variables) do
          strategy.update
        end
      end
    end
  end

  desc 'Create tarfile'
  task :create_tarfile => [:'gitcopy:update', :'gitcopy:set_current_revision'] do
    local_path = fetch(:local_path)

    run_locally do
      within local_path do
        with fetch(:git_environmental_variables) do
          strategy.release
        end
      end
    end
  end

  desc 'Copy repo to releases'
  task :create_release => :'gitcopy:create_tarfile' do

    on release_roles :all do
      within deploy_to do
        execute :mkdir, '-p', release_path
        extract_option = ["--extract"]
        extract_option << '--verbose' if fetch(:gitcopy_verbose)
        if (tree = fetch(:repo_tree))
          tree = tree.slice %r#^/?(.*?)/?$#, 1
          components = tree.split("/").size
          extract_option.concat ["--strip-components", components]
          extract_option.concat ["--file"]
        else
          extract_option.concat ["--file"]
        end
        upload! strategy.local_tarfile, strategy.remote_tarfile
        execute :tar, *extract_option, strategy.remote_tarfile, '--directory', release_path
        execute :rm, strategy.remote_tarfile
      end
    end

    run_locally do
      if File.exist? strategy.local_tarfile
        execute :rm, strategy.local_tarfile
      end
    end
  end

  desc 'Determine the revision that will be deployed'
  task :set_current_revision do
    local_path = fetch(:local_path)

    run_locally do
      within local_path do
        with fetch(:git_environmental_variables) do
          set :current_revision, strategy.fetch_revision
        end
      end
    end
  end
end
