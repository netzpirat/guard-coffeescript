require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class CoffeeScript < Guard

    autoload :Inspector, 'guard/coffeescript/inspector'
    autoload :Runner, 'guard/coffeescript/runner'
    autoload :Compiler, 'guard/coffeescript/compiler'

    def initialize(watchers = [], options = {})
      super(watchers, {
        :output => 'javascripts',
        :wrap => true,
        :shallow => false
      }.merge(options))
    end

    def run_all
      run_on_change(Watcher.match_files(self, Dir.glob(File.join('**', '*.coffee'))))
    end

    def run_on_change(paths)
      Runner.run(Inspector.clean(paths), watchers, options)
    end

  end
end
