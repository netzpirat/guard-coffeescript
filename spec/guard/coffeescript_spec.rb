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
    let(:guard) { Guard::CoffeeScript.new([Guard::Watcher.new('^x/(.*)\.coffee')]) }

    before do
      Dir.stub(:glob).and_return ['x/a.coffee', 'x/b.coffee', 'y/c.coffee']
    end

    it 'runs the run_on_change with all watched CoffeeScripts' do
      guard.should_receive(:run_on_change).with(['x/a.coffee', 'x/b.coffee'])
      guard.run_all
    end
  end

  describe '.run_on_change' do
    let(:guard) { Guard::CoffeeScript.new }

    it 'passes the paths to the Inspector for cleanup' do
      Guard::CoffeeScript::Inspector.should_receive(:clean).with(['a.coffee', 'b.coffee'])
      guard.run_on_change(['a.coffee', 'b.coffee'])
    end

    it 'starts the Runner with the cleaned files' do
      Guard::CoffeeScript::Inspector.should_receive(:clean).with(['a.coffee', 'b.coffee']).and_return ['a.coffee']
      Guard::CoffeeScript::Runner.should_receive(:run).with(['a.coffee'], [], { :output=>"javascripts", :wrap=>true, :shallow=>false })
      guard.run_on_change(['a.coffee', 'b.coffee'])
    end
  end
end
