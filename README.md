capistrano-scm-gitcopy
===================

A copy strategy for Capistrano 3, which mimics the `:copy` scm of Capistrano 2.
This Gem is inspired by and based on https://github.com/wercker/capistrano-scm-copy.
Thank wercker so much.

This will make Capistrano tar the a specific branch, upload it to the server(s) and then extract it in the release directory.

Requirements
============

Machine running Capistrano:

- Capistrano 3
- tar

Servers:

- mktemp
- tar

Installation
============

First make sure you install the capistrano-scm-gitcopy by adding it to your `Gemfile`:

    gem "capistrano-scm-gitcopy"

Then switch the `:scm` option to `:gitcopy` in `config/deploy.rb`:

    set :scm, :gitcopy
    

0.0.1
-----

- Initial release
