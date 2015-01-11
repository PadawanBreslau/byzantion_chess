lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'byzantion_chess/version'

Gem::Specification.new do |spec|

  spec.platform      = Gem::Platform::RUBY
  spec.name          = "byzantion_chess"
  spec.version       = ByzantionChess::VERSION
  spec.summary       = %q{Gem for chess}
  spec.description   = spec.summary

  spec.required_ruby_version     = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.3.6'

  spec.license       = 'MIT'

  spec.authors       = ["Padawan"]
  spec.email         = ["st.zawadzki@gmail.com"]
  #spec.homepage      = "https://github.com/TODO: Write your github username/byzantion_chess"

  spec.require_paths = ["lib"]
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency "bundler", ">= 1.2"
  spec.add_development_dependency "i18n"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
  spec.add_development_dependency "redcarpet", ">= 2.2"
  spec.add_development_dependency "yard", ">= 0.8.5.2"
  spec.add_development_dependency "simplecov", ">= 0.7.1"
  spec.add_development_dependency 'coveralls', '>= 0.6.1'
 # spec.add_development_dependency 'treetop'
end
