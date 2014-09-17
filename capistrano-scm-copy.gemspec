# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "capistrano-scm-copy"
  s.version     = "0.2.0"
  s.licenses    = ["MIT"]
  s.authors     = ["Benno van den Berg"]
  s.email       = ["bennovandenberg@gmail.com"]
  s.homepage    = "https://github.com/wercker/capistrano-scm-copy"
  s.summary     = %q{Copy strategy for capistrano 3.x}
  s.description = %q{Copy strategy for capistrano 3.x}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "capistrano", "~> 3.0"
end
