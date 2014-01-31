require 'spec_helper'

describe Guard::CoffeeScript::Inspector do
  let(:inspector) { Guard::CoffeeScript::Inspector }

  describe 'clean' do
    it 'removes duplicate files' do
      File.should_receive(:exists?).with("a.coffee").and_return true
      File.should_receive(:exists?).with("b.coffee.md").and_return true
      File.should_receive(:exists?).with("c.litcoffee").and_return true
      inspector.clean(['a.coffee', 'a.coffee', 'b.coffee.md', 'b.coffee.md', 'c.litcoffee', 'c.litcoffee'])
               .should == ['a.coffee', 'b.coffee.md', 'c.litcoffee']
    end

    it 'remove nil files' do
      File.should_receive(:exists?).with("a.coffee").and_return true
      File.should_receive(:exists?).with("b.coffee.md").and_return true
      File.should_receive(:exists?).with("c.litcoffee").and_return true
      inspector.clean(['a.coffee', 'b.coffee.md', 'c.litcoffee', nil])
               .should == ['a.coffee', 'b.coffee.md', 'c.litcoffee']
    end

    describe 'without the :missing_ok option' do
      it 'removes non-coffee files that do not exist' do
        File.should_receive(:exists?).with("a.coffee").and_return true
        File.should_receive(:exists?).with("c.litcoffee").and_return true
        File.should_receive(:exists?).with("d.coffee.md").and_return true
        File.should_receive(:exists?).with("doesntexist.coffee").and_return false
        inspector.clean(['a.coffee', 'b.txt', 'doesntexist.coffee', 'c.litcoffee', 'd.coffee.md'])
                 .should == ['a.coffee', 'c.litcoffee', 'd.coffee.md']
      end
    end

    describe 'with the :missing_ok options' do
      it 'removes non-coffee files' do
        inspector.clean(['a.coffee', 'b.txt', 'doesntexist.coffee', 'c.litcoffee', 'd.coffee.md'], { :missing_ok => true })
                 .should == ['a.coffee', 'doesntexist.coffee', 'c.litcoffee', 'd.coffee.md']
      end
    end

  end
end
