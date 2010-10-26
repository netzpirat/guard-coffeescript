require 'spec_helper'

describe Guard::CoffeeScript::Runner do
  let(:runner) { Guard::CoffeeScript::Runner }

  describe '.run' do
    context 'when no message option is passed' do
      it 'shows a default message' do
        runner.stub(:system).and_return true
        runner.stub(:`).and_return 0
        Guard::UI.should_receive(:info).with('Running: a.coffee', { :reset => true })
        runner.run(['a.coffee'])
      end
    end

    context 'when a custom message option is passed' do
      it 'shows the custom message' do
        runner.stub(:system).and_return true
        runner.stub(:`).and_return 0
        Guard::UI.should_receive(:info).with('Custom Message', { :reset => true })
        runner.run(['a.coffee'], { :message => 'Custom Message' })
      end
    end

    context 'when CoffeeScript is not installed' do
      it 'shows an error message that the coffee command is not installed' do
        runner.stub(:system).and_return false
        Guard::UI.should_receive(:error).with("Command 'coffee' not found. Please install CoffeeScript.")
        runner.run(['a.coffee'])
      end
    end
  end

  describe '.coffee_script_command' do
    it 'passes the paths to the coffee command' do
      runner.should_receive(:`).with('coffee -c -o js a.coffee b.coffee 2>&1').and_return 0
      runner.run(['a.coffee', 'b.coffee'], :output => 'js')
    end

    it 'passes the --no-wrap option to the coffee command' do
      runner.should_receive(:`).with('coffee -c --no-wrap -o js x.coffee y.coffee 2>&1').and_return 0
      runner.run(['x.coffee', 'y.coffee'], :output => 'js', :nowrap => true)
    end

    it 'passes the -o option to the coffee command' do
      runner.should_receive(:`).with('coffee -c -o output_path a.coffee b.coffee 2>&1').and_return 0
      runner.run(['a.coffee', 'b.coffee'], :output => 'output_path')
    end
  end
end
