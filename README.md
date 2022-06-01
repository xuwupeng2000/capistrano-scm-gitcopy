[  capistrano-scm-gitcopy ](https://github.com/xuwupeng2000/capsitrano-scm-gitcopy)
===================

Capistrano 3 :copy

A copy strategy for Capistrano 3, which mimics the `:copy` scm of Capistrano 2.
This Gem is inspired by and based on https://github.com/wercker/capistrano-scm-copy.
Thank wercker so much.

Why you should use this gem?
- no need to add id_rsa.pub to all your servers to deploy your remote code
- just add this gem and use your deploy service (your laptop) read from repo and deploy to your servers

This will make Capistrano tar the a specific git branch, upload it to the server(s) and then extract it in the release directory.

Release notes
============
0.1.5
- local_path is now configurable
- Use Git Revison as the name of tar file, also keep a proper revisions.log
- Add possibility to have tmp_dir_remote

0.1.4
- Tidy up
- New local tmp folder (/tmp/application-name/timestamp) so you can deploy without worry about clearup
- Remove incorrect README content

Requirements
============

Machine running Capistrano:

- Capistrano 3
- tar

Servers:

- mktemp
- tar
- ruby
- bundler (if you allow cap to run bundle for you)

Installation
============

First make sure you install the capistrano-scm-gitcopy by adding it to your `Gemfile`:

    gem "capistrano-scm-gitcopy"

Then switch the `:scm` option to `:gitcopy` in `config/deploy.rb`:

    set :scm, :gitcopy

Finally, DO NOT ADD `require 'capistrano/gitcopy'` to `Capfile` because `capistrano/setup` already loads the scm module with the :scm value you specified.

There is no default branch, you have to pass the branch you want to deploy as argument in the command line.


Usage
============

```bash
  bundle exec cap staging deploy branch=(your release branch)
  ```

Output is quiet by default set `gitcopy_verbose` to true in order get verbose output

```
set :gitcopy_verbose, true
```
