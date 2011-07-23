require 'spec_helper'

describe Guard::CoffeeScript::Formatter do

  subject { Guard::CoffeeScript::Formatter }

  describe '.info' do
    it 'output Guard::UI.info' do
      ::Guard::UI.should_receive(:info).once.with('a.coffee', {})
      subject.info('a.coffee')
    end
  end

  describe '.debug' do
    it 'output Guard::UI.debug' do
      ::Guard::UI.should_receive(:debug).once.with('a.coffee', {})
      subject.debug('a.coffee')
    end
  end

  describe '.error' do
    it 'colorize Guard::UI.error' do
      ::Guard::UI.should_receive(:error).once.with("\e[0;31ma.coffee\e[0m", {})
      subject.error('a.coffee')
    end
  end

  describe '.success' do
    it 'colorize Guard::UI.info' do
      ::Guard::UI.should_receive(:info).once.with("\e[0;32ma.coffee\e[0m", {})
      subject.success('a.coffee')
    end
  end

  describe '.notify' do
    it 'output Guard::Notifier.notify' do
      ::Guard::Notifier.should_receive(:notify).once.with('a.coffee', {})
      subject.notify('a.coffee')
    end
  end

end
