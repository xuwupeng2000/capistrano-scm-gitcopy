# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'capistrano-scm-gitcopy'
  s.version     = '0.1.5'
  s.licenses    = ['MIT']
  s.authors     = ['Jack Wu', 'Carl Douglas']
  s.email       = ['xuwupeng2000@gmail.com']
  s.homepage    = 'https://github.com/xuwupeng2000/capsitrano-scm-gitcopy.git'
  s.summary     = %q{Gitcopy strategy for capistrano 3.x}
  s.description = %q{Gitcopy strategy for capistrano 3.x}

  s.files         = `git ls-files`.split
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split
  s.executables   = `git ls-files -- bin/*`.split.map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  # specify any dependencies here; for example:
  s.add_dependency 'capistrano', '~> 3.0'

  s.add_development_dependency 'rspec', '~> 3.0.0'
  s.add_development_dependency 'mocha', '~> 1.1.0'
end
