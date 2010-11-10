require 'spec_helper'

describe Guard::CoffeeScript do
  before do
    Guard::CoffeeScript::Inspector.stub(:clean)
    Guard::CoffeeScript::Runner.stub(:run)
  end

  describe '#initialize' do
    context 'when no options are provided' do
      let(:guard) { Guard::CoffeeScript.new }

      it 'sets a default :output option' do
        guard.options[:output].should eql 'javascripts'
      end

      it 'sets a default :wrap option' do
        guard.options[:wrap].should be_true
      end

      it 'sets a default :shallow option' do
        guard.options[:shallow].should be_false
      end
    end

    context 'with other options than the default ones' do
      let(:guard) { Guard::CoffeeScript.new(nil, { :output => 'output_folder', :wrap => false, :shallow => true }) }

      it 'sets the provided :output option' do
        guard.options[:output].should eql 'output_folder'
      end
 
      it 'sets the provided :wrap option' do
        guard.options[:wrap].should be_false
      end

      it 'sets the provided :shallow option' do
        guard.options[:shallow].should be_true
      end
    end
  end

  describe '.run_all' do
  end

  describe '.run_on_change' do
  end
end
