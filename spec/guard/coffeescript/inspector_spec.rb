require 'spec_helper'

describe Guard::CoffeeScript::Inspector do
  let(:inspector) { Guard::CoffeeScript::Inspector }

  describe 'clean' do
    it 'removes duplicate files' do
      File.should_receive(:exists?).with("a.coffee").and_return true
      inspector.clean(['a.coffee', 'a.coffee']).should == ['a.coffee']
    end

    it 'remove nil files' do
      File.should_receive(:exists?).with("a.coffee").and_return true
      inspector.clean(['a.coffee', nil]).should == ['a.coffee']
    end

    describe 'without the :missing_ok option' do
      it 'removes non-coffee files that does not exist' do
        File.should_receive(:exists?).with("a.coffee").and_return true
        File.should_receive(:exists?).with("doesntexist.coffee").and_return false
        inspector.clean(['a.coffee', 'b.txt', 'doesntexist.coffee']).should == ['a.coffee']
      end
    end

    describe 'with the :missing_ok options' do
      it 'removes non-coffee files' do
        inspector.clean(['a.coffee', 'b.txt', 'doesntexist.coffee'], { :missing_ok => true }).should == ['a.coffee', 'doesntexist.coffee']
      end
    end

  end
end
