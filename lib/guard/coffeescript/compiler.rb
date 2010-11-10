module Guard
  class CoffeeScript
    # This has been kindly borrowed from https://github.com/josh/ruby-coffee-script/raw/master/lib/coffee_script.rb
    # due to namespace conflicts
    module Compiler
      class << self
        def locate_coffee_bin
          out = `which coffee`
          if $?.success?
            out.chomp
          else
            raise LoadError, "could not find `coffee` in PATH"
          end
        end

        def coffee_bin
          @@coffee_bin ||= locate_coffee_bin
        end

        def coffee_bin=(path)
          @@coffee_bin = path
        end

        def version
          `#{coffee_bin} --version`[/(\d|\.)+/]
        end

        # Compile a script (String or IO) to JavaScript.
        def compile(script, options = {})
          args = "-sp"

          if options[:wrap] == false ||
              options.key?(:bare) ||
              options.key?(:no_wrap)
            args += " --#{no_wrap_flag}"
          end

          execute_coffee(script, args)
        end

        # Evaluate a script (String or IO) and return the stdout.
        # Note: the first argument will be process.argv[3], the second
        # process.argv[4], etc.
        def evaluate(script, *args)
          execute_coffee(script, "-s #{args.join(' ')}")
        end

        private
          def execute_coffee(script, args)
            command = "#{coffee_bin} #{args} 2>&1"
            script  = script.read if script.respond_to?(:read)

            IO.popen(command, "w+") do |f|
              f << script
              f.close_write
              f.read
            end
          end

          def no_wrap_flag
            if `#{coffee_bin} --help`.lines.grep(/--no-wrap/).any?
              'no-wrap'
            else
              'bare'
            end
          end
      end
    end
  end
end