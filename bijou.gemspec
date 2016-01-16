# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bijou/version'

Gem::Specification.new do |spec|
  spec.name          = "bijou"
  spec.version       = Bijou::VERSION
  spec.authors       = ["Daniel Chinedu"]
  spec.email         = ["chinedudaniel7@gmail.com"]

  spec.summary       = %q{A very simple mvc framework.}
  spec.description   = %q{A simple rack powered ruby web framework.}
  spec.homepage      = "https://github.com/andela-cdaniel/bijou"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "capybara", "2.5.0"
  spec.add_development_dependency "pry", "0.10.3"
  spec.add_development_dependency "pry-nav", "0.2.4"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rubocop"

  spec.add_runtime_dependency "rack", "1.6.4"
  spec.add_runtime_dependency "sqlite3", "1.3.11"
  spec.add_runtime_dependency "erubis", "2.7.0"
  spec.add_runtime_dependency "tilt", "2.0.1"
end
