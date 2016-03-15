# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rancher/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'rancher-api'
  spec.version       = Rancher::Api::VERSION
  spec.authors       = ['Alex Kurkin']
  spec.email         = ['thaold@thaold.com']

  spec.summary       = 'Easily connect to Rancher API!'
  spec.description   = 'Ruby gem to easily connect to Rancher API. Via this gem you can do anything that API lets you to do it'
  spec.homepage      = 'https://github.com/akurkin/rancher-api'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'her', '~> 0.7.6'
  spec.add_dependency 'faye-websocket'
  spec.add_dependency 'faraday_middleware'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'webmock', '1.21.0'
  spec.add_development_dependency 'vcr', '2.9.3'
end
