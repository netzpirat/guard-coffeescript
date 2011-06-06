source 'http://rubygems.org'

# Specify your gem's dependencies in guard-coffee-script.gemspec
gemspec

gem 'rake'

require 'rbconfig'

platform :ruby_18 do
  gem 'json'
end

if Config::CONFIG['target_os'] =~ /darwin/i
  gem 'rb-fsevent', '>= 0.4.0'
  gem 'growl',      '~> 1.0.3'
end
if Config::CONFIG['target_os'] =~ /linux/i
  gem 'rb-inotify', '>= 0.8.4'
  gem 'libnotify',  '~> 0.3.0'
end

# The JS runtime is needed because ExecJS searches one when the module is loaded.
# This breaks travis builds even when the compiler is stubbed.

if defined?(JRUBY_VERSION)
  gem 'therubyrhino'
else
  gem 'therubyracer'
end
