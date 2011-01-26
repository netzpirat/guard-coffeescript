require 'spec_helper'

describe Guard::CoffeeScriptGuard do

  before do
    Guard::CoffeeScriptGuard::Inspector.stub(:clean)
    Guard::CoffeeScriptGuard::Runner.stub(:run)
  end

  describe '#initialize' do
    context 'when no options are provided' do
      let(:guard) { Guard::CoffeeScriptGuard.new }

      it 'sets a default :output option' do
        guard.options[:output].should eql 'javascripts'
      end

      it 'sets a default :wrap option' do
        guard.options[:bare].should be_false
      end

      it 'sets a default :shallow option' do
        guard.options[:shallow].should be_false
      end
    end

    context 'with other options than the default ones' do
      let(:guard) { Guard::CoffeeScriptGuard.new(nil, { :output => 'output_folder', :bare => true, :shallow => true }) }

      it 'sets the provided :output option' do
        guard.options[:output].should eql 'output_folder'
      end
 
      it 'sets the provided :bare option' do
        guard.options[:bare].should be_true
      end

      it 'sets the provided :shallow option' do
        guard.options[:shallow].should be_true
      end
    end
  end

  describe '.run_all' do
    let(:guard) { Guard::CoffeeScriptGuard.new([Guard::Watcher.new('^x/(.*)\.coffee')]) }

    before do
      Dir.stub(:glob).and_return ['x/a.coffee', 'x/b.coffee', 'y/c.coffee']
    end

    it 'runs the run_on_change with all watched CoffeeScripts' do
      guard.should_receive(:run_on_change).with(['x/a.coffee', 'x/b.coffee'])
      guard.run_all
    end
  end

  describe '.run_on_change' do
    let(:guard) { Guard::CoffeeScriptGuard.new }

    before do
      guard.stub(:notify)
    end

    it 'passes the paths to the Inspector for cleanup' do
      Guard::CoffeeScriptGuard::Inspector.should_receive(:clean).with(['a.coffee', 'b.coffee'])
      guard.run_on_change(['a.coffee', 'b.coffee'])
    end

    it 'starts the Runner with the cleaned files' do
      Guard::CoffeeScriptGuard::Inspector.should_receive(:clean).with(['a.coffee', 'b.coffee']).and_return ['a.coffee']
      Guard::CoffeeScriptGuard::Runner.should_receive(:run).with(['a.coffee'], [], {
          :output => 'javascripts',
          :bare => false,
          :shallow => false }).and_return ['a.js']
      guard.run_on_change(['a.coffee', 'b.coffee'])
    end

    it 'notifies the other guards about the changed files' do
      Guard::CoffeeScriptGuard::Runner.should_receive(:run).and_return ['a.js', 'b.js']
      guard.should_receive(:notify).with(['a.js', 'b.js'])
      guard.run_on_change(['a.coffee', 'b.coffee'])
    end
  end
end
