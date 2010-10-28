require 'open3'

module Guard
  class CoffeeScript
    module Runner
      class << self
        include Open3

        def run(paths, options = {})

          if coffee_executable_exists?
            message = options[:message] || "Compile #{paths.join(' ')}"
            ::Guard::UI.info message, :reset => true

            output, status = capture2e(coffee_script_command(paths, options))

            puts output

            if status.to_i == 0
              message = message.gsub(/^Compile/, 'Successfully compiled')
              ::Guard::Notifier.notify(message, :title => 'CoffeeScript results')
            else
              message = output.split("\n").select { |line| line =~ /^Error:/ }.join("\n")
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
