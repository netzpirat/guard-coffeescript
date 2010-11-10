module Guard
  class CoffeeScript
    module Runner
      class << self
        
        def run(files, watchers, options = {})
          message = options[:message] || "Compile #{ files.join(' ') }"
          ::Guard::UI.info message, :reset => true

          errors = []
          directories = options[:directories] ? detect_nested_directories(watchers, files, options) : { options[:output] => files }

          directories.each do |directory, scripts|
            directory = File.expand_path(directory)

            scripts.each do |file|
              content = Compiler.compile(File.open(file), options)
              if $?.success?
                FileUtils.mkdir_p(directory) if !File.directory?(directory)
                File.open(File.join(directory, File.basename(file)), 'w') { |f| f.write(content) }
              else
                errors << File.join(directory, File.basename(file)) + ': ' + content.split("\n").select { |line| line =~ /^Error:/ }.join("\n")
                ::Guard::UI.error(content)
              end
            end
          end

          if errors.empty?
            message = message.gsub(/^Compile/, 'Successfully compiled')
            ::Guard::Notifier.notify(message, :title => 'CoffeeScript results')
          else
            puts errors.inspect
            ::Guard::Notifier.notify(errors.join("\n"), :title => 'CoffeeScript results', :image => :failed)
          end
          
        rescue LoadError
          ::Guard::UI.error "Command 'coffee' not found. Please install CoffeeScript."    
        end

      private

        def detect_nested_directories(watchers, files, options)
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

      end
    end
  end
end