capistrano-scm-copy
===================

A copy strategy for Capistrano 3, which mimics the `:copy` scm of Capistrano 2.

This will make Capistrano tar the current directory, upload it to the server(s) and then extract it in the release directory.

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

First make sure you install the capistrano-scm-copy by adding it to your `Gemfile`:

    gem "capistrano-scm-copy"

Then switch the `:scm` option to `:copy` in `config/deploy.rb`:

    set :scm, :copy
    
TODO
====

I'm new to programming for Capistrano and even Ruby in general. So any feedback is appreciated. 

License
=======

The MIT License (MIT)

Changelog
=========

0.1.0
-----

- Add `:include_dir`

0.0.2
-----

- Add `task :set_current_revision` 

0.0.1
-----

- Initial release
