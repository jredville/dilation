# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dilation/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "dilation"
  gem.authors       = ["Jim Deville"]
  gem.email         = ["james.deville@gmail.com"]
  gem.description   = %q{A controllable timer}
  gem.summary       = %q{A timer that provides an event based interface to hook into for your app. In addition, the back end timer can be swapped out, so for testing, you can control the passage of time.}
  gem.homepage      = "http://github.com/jredville/dilation"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = Dilation::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.9.2'
  gem.required_rubygems_version = '>= 1.3.5'

  gem.add_dependency('celluloid')
  gem.add_development_dependency('rake', '~> 0.9.2')
  gem.add_development_dependency('rspec')
end
