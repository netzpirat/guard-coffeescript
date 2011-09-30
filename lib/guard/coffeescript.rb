require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard

  # The CoffeeScript guard that gets notifications about the following
  # Guard events: `start`, `stop`, `reload`, `run_all` and `run_on_change`.
  #
  class CoffeeScript < Guard

    autoload :Formatter, 'guard/coffeescript/formatter'
    autoload :Inspector, 'guard/coffeescript/inspector'
    autoload :Runner, 'guard/coffeescript/runner'

    # Initialize Guard::CoffeeScript.
    #
    # @param [Array<Guard::Watcher>] watchers the watchers in the Guard block
    # @param [Hash] options the options for the Guard
    # @option options [String] :input the input directory
    # @option options [String] :output the output directory
    # @option options [Boolean] :bare do not wrap the output in a top level function
    # @option options [Boolean] :shallow do not create nested directories
    # @option options [Boolean] :hide_success hide success message notification
    # @option options [Boolean] :noop do not generate an output file
    #
    def initialize(watchers = [], options = { })
      watchers = [] if !watchers
      defaults = {
          :bare         => false,
          :shallow      => false,
          :hide_success => false,
          :noop         => false
      }

      if options[:input]
        defaults.merge!({ :output => options[:input] })
        watchers << ::Guard::Watcher.new(%r{^#{ options.delete(:input) }/(.+\.coffee)$})
      end

      super(watchers, defaults.merge(options))
    end

    # Gets called once when guard starts.

    def start
      run_all if @options[:all_on_start]
    end

    # Gets called when all files should be regenerated.
    #
    # @return [Boolean] when running all specs was successful
    #
    def run_all
      UI.info "Running everything!!"
      run_on_change(Watcher.match_files(self, Dir.glob(File.join('**', '*.coffee'))))
    end

    # Gets called when watched paths and files have changes.
    #
    # @param [Array<String>] paths the changed paths and files
    # @return [Boolean] when running the changed specs was successful
    #
    def run_on_change(paths)
      changed_files, success = Runner.run(Inspector.clean(paths), watchers, options)
      notify changed_files

      success
    end

    private

    # Notify changed files back to Guard, so that other Guards can continue
    # to work with the generated files.
    #
    # @param [Array<String>] changed_files the files that have been changed
    #
    def notify(changed_files)
      ::Guard.guards.each do |guard|
        paths = Watcher.match_files(guard, changed_files)
        guard.run_on_change paths unless paths.empty?
      end
    end

  end
end
