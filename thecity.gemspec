lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_city/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'faraday', ['>= 0.8', '< 0.10']
  spec.add_dependency 'http', '~> 0.5.0'
  spec.add_dependency 'http_parser.rb', '~> 0.5.3'
  spec.add_dependency 'json', '~> 1.8'
  #spec.add_dependency 'simple_oauth', '~> 0.2.0'
  #spec.add_dependency 'tzinfo', '~> 1.0.1'
  #spec.add_dependency 'tzinfo-data', "~> 1.2013.4"
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.authors = ["Robert Leib"]
  spec.description = %q{A Ruby interface to The City API.}
  spec.email = ["robert.leib@gmail.com"]
  spec.files = %w(CHANGELOG.md LICENSE.md README.md Rakefile thecity.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("spec/**/*")
  spec.homepage = 'http://github.com/robertleib/thecity-ruby/'
  spec.licenses = ['MIT']
  spec.name = 'thecity'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary = spec.description
  spec.test_files = Dir.glob("spec/**/*")
  spec.version = TheCity::Version
end
