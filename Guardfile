guard 'rspec', :version => 2, :rvm => ['1.8.7', '1.9.2'] do
  watch('^spec/(.*)_spec.rb')
  watch('^lib/(.*).rb')          { |m| "spec/#{m[1]}_spec.rb" }
  watch('^spec/spec_helper.rb')  { 'spec' }
end
