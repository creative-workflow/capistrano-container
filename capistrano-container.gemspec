# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = 'capistrano-container'
  spec.version     = '0.0.3'
  spec.date        = '2016-09-26'
  spec.summary     = 'Helps managing docker container and files inside docker container for Capistrano 3.x'
  spec.description = spec.summary
  spec.authors     = ['Tom Hanoldt']
  spec.email       = ['tom@creative-workflow.berlin']
  spec.homepage    = 'https://github.com/creative-workflow/capistrano-container'
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '>= 3.0.0.pre'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.1'
end
