require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class CoffeeScript < Guard

    autoload :Formatter, 'guard/coffeescript/formatter'
    autoload :Inspector, 'guard/coffeescript/inspector'
    autoload :Runner, 'guard/coffeescript/runner'

    def initialize(watchers = [], options = {})
      watchers = [] if !watchers
      defaults = {
          :bare => false,
          :shallow => false,
          :hide_success => false,
      }

      if options[:input]
        defaults.merge!({ :output => options[:input] })
        watchers << ::Guard::Watcher.new(%r{#{ options.delete(:input) }/(.+\.coffee)})
      end

      super(watchers, defaults.merge(options))
    end

    def run_all
      run_on_change(Watcher.match_files(self, Dir.glob(File.join('**', '*.coffee'))))
    end

    def run_on_change(paths)
      changed_files = Runner.run(Inspector.clean(paths), watchers, options)
      notify changed_files
    end

    private

    def notify(changed_files)
      ::Guard.guards.each do |guard|
        paths = Watcher.match_files(guard, changed_files)
        guard.run_on_change paths unless paths.empty?
      end
    end

  end
end
