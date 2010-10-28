require 'spec_helper'

describe Guard::CoffeeScript do
  before do
    Guard::CoffeeScript::Runner.stub(:system).and_return true
    Guard::CoffeeScript::Runner.stub(:capture2e).and_return ['', 0]
  end

  describe '#initialize' do
    context 'when no options are provided' do
      let(:guard) { Guard::CoffeeScript.new }

      it 'defines a default output folder' do
        guard.options[:output].should eql 'javascripts'
      end

      it 'defines a default nowrap options' do
        guard.options[:nowrap].should be_false
      end
    end

    context 'when a default output option is provided' do
      let(:guard) { Guard::CoffeeScript.new(nil, { :output => 'output_folder' }) }

      it 'transfers the output folder' do
        guard.options[:output].should eql 'output_folder'
      end
    end

    context 'when a default nowrap option is provided' do
      let(:guard) { Guard::CoffeeScript.new(nil, { :nowrap => true }) }

      it 'transfers the output folder' do
        guard.options[:output].should be_true
      end
    end
  end

  describe '#run_all' do
    before do
      Dir.stub(:glob).and_return ['a.coffee', 'x/b.coffee', 'x/c.coffee', 'x/y/d.coffee']
    end

    context 'a single CoffeeScript watcher' do
     let(:guard) { Guard::CoffeeScript.new([Guard::Watcher.new('(.*).coffee$')]) }

     it 'runs all watched CoffeeScript files' do
      Guard::CoffeeScript::Runner.should_receive(:run).with(
          ['a.coffee'],
          { :output => 'javascripts', :nowrap => false, :message => 'Compile all CoffeeScripts' }).and_return true

      guard.run_all
      end
    end

    context 'a directory CoffeeScript watcher' do
     let(:guard) { Guard::CoffeeScript.new([Guard::Watcher.new('^x/(.*).coffee$')]) }

     it 'runs all watched CoffeeScript files' do
      Guard::CoffeeScript::Runner.should_receive(:run).with(
          ['x/b.coffee', 'x/c.coffee', 'x/y/d.coffee'],
          { :output => 'javascripts', :nowrap => false, :message => 'Compile all CoffeeScripts' }).and_return true

      guard.run_all
      end
    end
  end

  describe "#run_on_change" do
    before do
      Dir.stub(:glob).and_return ['a.coffee']
    end

    let(:guard) { Guard::CoffeeScript.new }

    it 'should pass the matched paths to the inspector for cleanup' do
      Guard::CoffeeScript::Inspector.should_receive(:clean).with(['a.coffee']).and_return ['a.coffee']
      guard.run_on_change(['a.coffee'])
    end

    it 'should run on the changed paths' do
      Guard::CoffeeScript::Runner.should_receive(:run).with(['a.coffee'], { :output => 'javascripts', :nowrap => false })
      guard.run_on_change(['a.coffee'])
    end
  end
end
