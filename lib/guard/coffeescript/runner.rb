module Guard
  class CoffeeScript
    module Runner
      class << self

        def run(files, watchers, options = {})
          message = notify_start(files, options)
          errors = compile(files, options, watchers)
          notify_result(errors, message)
          
        rescue LoadError
          ::Guard::UI.error "Command 'coffee' not found. Please install CoffeeScript."    
        end

      private

        def notify_start(files, options)
          message = options[:message] || "Compile #{ files.join(' ') }"
          ::Guard::UI.info message, :reset => true
          message
        end

        def compile(files, options, watchers)
          errors      = []
          directories = detect_nested_directories(watchers, files, options)

          directories.each do |directory, scripts|
            directory = File.expand_path(directory)
            scripts.each do |file|
              content = Compiler.compile(File.open(file), options)
              process_compile_result(content, directory, errors, file)
            end
          end

          errors
        end

        def process_compile_result(content, directory, errors, file)
          if $?.success?
            FileUtils.mkdir_p(directory) if !File.directory?(directory)
            File.open(File.join(directory, File.basename(file)), 'w') { |f| f.write(content) }
          else
            errors << File.join(directory, File.basename(file)) + ': ' + content.split("\n").select { |line| line =~ /^Error:/ }.join("\n")
            ::Guard::UI.error(content)
          end
        end

        def detect_nested_directories(watchers, files, options)
          return { options[:output] => files } if options[:shallow]

          directories = {}

          watchers.product(files) do |watcher, file|
            if matches = file.match(watcher.pattern)
              target = File.join(options[:output], File.dirname(matches[1]))
              if directories[target]
                directories[target] << file
              else
                directories[target] = [file]
              end
            end
          end

          directories
        end

        def notify_result(errors, message)
          if errors.empty?
            message = message.gsub(/^Compile/, 'Successfully compiled')
            ::Guard::Notifier.notify(message, :title => 'CoffeeScript results')
          else
            ::Guard::Notifier.notify(errors.join("\n"), :title => 'CoffeeScript results', :image => :failed)
          end
        end

      end
    end
  end
end