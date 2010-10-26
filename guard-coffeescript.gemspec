# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'guard/coffeescript/version'

Gem::Specification.new do |s|
  s.name        = 'guard-coffeescript'
  s.version     = Guard::CoffeeScriptVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Michael Kessler']
  s.email       = ['michi@netzpiraten.ch']
  s.homepage    = 'http://rubygems.org/gems/guard-coffeescript'
  s.summary     = 'Guard gem for CoffeeScript'
  s.description = 'Guard::CoffeeScript automatically generates your JavaScripts from your CoffeeScripts'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project = 'guard-coffeescript'

  s.add_dependency 'guard', '>= 0.2.0'
  s.add_development_dependency 'rspec',       '~> 2.0.1'
  s.add_development_dependency 'guard-rspec', '~> 0.1.4'

  s.add_development_dependency 'bundler', '>= 1.0.2'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.rdoc]
  s.require_path = 'lib'
end
