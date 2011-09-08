require 'spec_helper'

describe Guard::CoffeeScriptVersion do
  describe 'VERSION' do
    it 'defines the version' do
      Guard::CoffeeScriptVersion::VERSION.should match /\d+.\d+.\d+/
    end
  end
end
