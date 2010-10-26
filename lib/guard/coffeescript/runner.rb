module Guard
  class CoffeeScript
    module Runner
      class << self

        def run(paths, options = {})
          if coffee_executable_exists?
            message = options[:message] || "Running: #{paths.join(' ')}"
            ::Guard::UI.info message, :reset => true

            out = `#{ coffee_script_command(paths, options) } 2>&1`
            if $?.to_i == 0
              message = message.gsub(/Running:/, 'Successful compiled')
              ::Guard::Notifier.notify(message, :title => 'CoffeeScript results')
            else
              message = out.split("\n").select { |line| line =~ /^Error:/ }.join("\n")
              ::Guard::Notifier.notify(message, :title => 'CoffeeScript results', :image => :failed)
            end

          else
            ::Guard::UI.error "Command 'coffee' not found. Please install CoffeeScript."
          end
        end

      private

        def coffee_script_command(paths, options)
          cmd_parts = []
          cmd_parts << 'coffee'
          cmd_parts << '-c'
          cmd_parts << '--no-wrap' if options[:nowrap]
          cmd_parts << "-o #{ options[:output] }"
          cmd_parts << paths.join(' ')
          cmd_parts.join(' ')
        end

        def coffee_executable_exists?
          system('which coffee > /dev/null 2>/dev/null')
        end

      end
    end
  end
end
