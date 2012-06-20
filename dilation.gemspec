# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dilation/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jim Deville"]
  gem.email         = ["james.deville@gmail.com"]
  gem.description   = %q{A controllable timer}
  gem.summary       = %q{A controllable timer}
  gem.homepage      = "http://github.com/jredville/dilation"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dilation"
  gem.require_paths = ["lib"]
  gem.version       = Dilation::VERSION
  gem.add_dependency('celluloid')
  gem.add_development_dependency('rake', '~> 0.9.2')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('pry')
end
