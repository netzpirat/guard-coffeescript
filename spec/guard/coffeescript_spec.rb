require 'spec_helper'

describe Guard::CoffeeScript do
  before do
    Guard::CoffeeScript::Runner.stub(:system).and_return true
    Guard::CoffeeScript::Runner.stub(:`).and_return ''
  end

  describe '#initialize' do
    context 'when no options are provided' do
      let(:guard) { Guard::CoffeeScript.new }

      it 'defines a default output folder' do
        guard.options[:output].should eql 'javascripts'
      end

      it 'defines a default nowrap option' do
        guard.options[:wrap].should be_true
      end

      it 'defines a default directory option' do
        guard.options[:directory].should be_true
      end
    end

    context 'when a output option is provided' do
      let(:guard) { Guard::CoffeeScript.new(nil, { :output => 'output_folder' }) }

      it 'uses the output folder' do
        guard.options[:output].should eql 'output_folder'
      end
    end

    context 'when a wrap option is provided' do
      let(:guard) { Guard::CoffeeScript.new(nil, { :wrap => false }) }

      it 'uses the wrap option' do
        guard.options[:wrap].should be_false
      end
    end

    context 'when a directory option is provided' do
      let(:guard) { Guard::CoffeeScript.new(nil, { :directory => false }) }

      it 'uses the directory option' do
        guard.options[:directory].should be_false
      end
    end
  end


end
