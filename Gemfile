source :rubygems

gemspec

gem 'rake'

platform :ruby do
  gem 'rb-readline'
end

platform :ruby_18 do
  gem 'json'
end

# The JS runtime is needed because ExecJS searches one when the module is loaded.
# This breaks travis builds even when the compiler is stubbed.
platform :jruby do
  gem 'therubyrhino'
end

require 'rbconfig'

if RbConfig::CONFIG['target_os'] =~ /darwin/i
  gem 'ruby_gntp', :require => false
elsif RbConfig::CONFIG['target_os'] =~ /linux/i
  gem 'libnotify', :require => false
elsif RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
  gem 'win32console', :require => false
  gem 'rb-notifu', :require => false
end