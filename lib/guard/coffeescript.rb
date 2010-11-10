require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class CoffeeScript < Guard

    autoload :Inspector, 'guard/coffeescript/inspector'
    autoload :Runner, 'guard/coffeescript/runner'
    autoload :Compiler, 'guard/coffeescript/compiler'

    def initialize(watchers = [], options = {})
      super watchers, options
      options[:output] ||= 'javascripts'
      options[:wrap] ||= true
      options[:directories] ||= true
    end

    def run_all
      Runner.run(Inspector.clean(Watcher.match_files(self, Dir.glob(File.join('**', '*.coffee')))), watchers, options)
    end

    def run_on_change(paths)
      Runner.run(Inspector.clean(paths), watchers, options)
    end

  end
end
