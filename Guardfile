guard 'rspec' do
  watch(%r{spec/spec_helper\.rb}) { 'spec' }
  watch(%r{spec/.+_spec.rb})
  watch(%r{lib/(.+).rb})       { |m| "spec/#{ m[1] }_spec.rb" }
end
