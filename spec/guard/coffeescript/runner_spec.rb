require 'spec_helper'

describe Guard::CoffeeScriptGuard::Runner do
  describe '#run' do
    let(:runner)  { Guard::CoffeeScriptGuard::Runner }
    let(:watcher) { Guard::Watcher.new('^(.*)\.coffee') }

    before do
      runner.stub(:compile).and_return ''
      FileUtils.stub(:mkdir_p)
      File.stub(:open)
    end

    it 'shows a start notification' do
      ::Guard::UI.should_receive(:info).with('Compile a.coffee, b.coffee', { :reset => true })
      runner.run(['a.coffee', 'b.coffee'], [])
    end

    context 'with the :shallow option set to false' do
      let(:watcher) { Guard::Watcher.new('^app/coffeescripts/(.*)\.coffee') }

      it 'compiles the CoffeeScripts to the output and creates nested directories' do
        FileUtils.should_receive(:mkdir_p).with("#{ @project_path }/javascripts/x/y")
        File.should_receive(:open).with("#{ @project_path }/javascripts/x/y/a.js", 'w')
        runner.run(['app/coffeescripts/x/y/a.coffee'], [watcher], { :output => 'javascripts', :shallow => false })
      end
    end

    context 'with the :shallow option set to true' do
      let(:watcher) { Guard::Watcher.new('^app/coffeescripts/(.*)\.coffee') }

      it 'compiles the CoffeeScripts to the output without creating nested directories' do
        FileUtils.should_receive(:mkdir_p).with("#{ @project_path }/javascripts")
        File.should_receive(:open).with("#{ @project_path }/javascripts/a.js", 'w')
        runner.run(['app/coffeescripts/x/y/a.coffee'], [watcher], { :output => 'javascripts', :shallow => true })
      end
    end

    context 'with compilation errors' do
      it 'shows the error messages' do
        runner.should_receive(:compile).and_raise CoffeeScript::CompilationError.new("Parse error on line 2: Unexpected 'UNARY'")
        Guard::Notifier.should_receive(:notify).with("a.coffee: Parse error on line 2: Unexpected 'UNARY'", :title => 'CoffeeScript results', :image => :failed)
        runner.run(['a.coffee'], [watcher], { :output => 'javascripts' })
      end
    end

    context 'without compilation errors' do
      it 'shows a success messages' do
        runner.should_receive(:compile).with('a.coffee', { :output => 'javascripts' }).and_return ["OK", true]
        Guard::Notifier.should_receive(:notify).with('Successfully generated javascripts/a.js', :title => 'CoffeeScript results')
        runner.run(['a.coffee'], [watcher], { :output => 'javascripts' })
      end
    end
  end
end