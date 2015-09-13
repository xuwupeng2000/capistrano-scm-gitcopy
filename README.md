[ capistrano-scm-gitcopy ](https://github.com/xuwupeng2000/capsitrano-scm-gitcopy)
===================

Capistrano 3 :copy 

A copy strategy for Capistrano 3, which mimics the `:copy` scm of Capistrano 2.
This Gem is inspired by and based on https://github.com/wercker/capistrano-scm-copy.
Thank wercker so much.

This will make Capistrano tar the a specific git branch, upload it to the server(s) and then extract it in the release directory.

There is `sub_directory` option. 
When specified, onthe the subtree of the checked-out repository will be deployed. 
This is useful when the rails application is not at the root of the repository.

Requirements
============

Machine running Capistrano:

- Capistrano 3
- tar

Servers:

- mktemp
- tar
- ruby

Installation
============

First make sure you install the capistrano-scm-gitcopy by adding it to your `Gemfile`:

    gem "capistrano-scm-gitcopy"

Then switch the `:scm` option to `:gitcopy` in `config/deploy.rb`:

    set :scm, :gitcopy
    
Finally, DO NOT ADD `require 'capistrano/gitcopy'` to `Capfile` because `capistrano/setup` already loads the scm module with the :scm value you specified.


Usage
============

```bash
  cap uat deploy -s branch=(your release branch)
  ```
