require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class CoffeeScript < Guard

    autoload :Runner, 'guard/coffeescript/runner'
    autoload :Inspector, 'guard/coffeescript/inspector'

    def initialize(watchers = [], options = {})
      @watchers, @options = watchers, options
      @options[:output] ||= 'javascripts'
      @options[:nowrap] ||= false
    end

    def run_all
      paths = Inspector.clean(Watcher.match_files(self, Dir.glob(File.join('**', '*.coffee'))))
      Runner.run(paths, options.merge(:message => 'Generate all CoffeeScripts')) unless paths.empty?
    end

    def run_on_change(paths)
      paths = Inspector.clean(paths)
      Runner.run(paths, options) unless paths.empty?
    end

  end
end
