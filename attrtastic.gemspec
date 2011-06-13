# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "attrtastic/version"

Gem::Specification.new do |s|
  s.name        = "attrtastic"
  s.version     = Attrtastic::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Boruta Mirosław"]
  s.email       = ["boruta.miroslaw@gmail.com"]
  s.homepage    = "http://github.com/MBO/attrtastic"
  s.summary     = %q{Rails view helper for scaffolding show/index pages for objects}
  s.description = %q{Rails view helper for scaffolding show/index pages for objects}

  s.rubyforge_project = "attrtastic"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency("yard", ["~> 0.6.0"])
  s.add_development_dependency("bluecloth", ["~>2.0.0"])
  s.add_development_dependency("shoulda", ["~> 2.11.0"])

  s.add_dependency("activesupport", [">= 3.0"])
  s.add_dependency("actionpack", [">= 3.0"])
end
