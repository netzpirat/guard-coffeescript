module Guard
  class CoffeeScript
    module Runner
      class << self

        def run(files, watchers, options = {})
          notify_start(files, options)
          changed_files, errors = compile_files(files, options, watchers)
          notify_result(changed_files, errors)

          changed_files
        rescue LoadError
          ::Guard::UI.error "Command 'coffee' not found. Please install CoffeeScript."    
        end

      private

        def notify_start(files, options)
          message = options[:message] || "Compile #{ files.join(', ') }"
          ::Guard::UI.info message, :reset => true
        end

        def compile_files(files, options, watchers)
          errors        = []
          changed_files = []
          directories   = detect_nested_directories(watchers, files, options)

          directories.each do |directory, scripts|
            scripts.each do |file|
              content, success = compile(file, options)
              changed_files << process_compile_result(content, file, directory, errors, success)
            end
          end

          [changed_files.compact, errors]
        end

        def compile(file, options)
          content = Compiler.compile(File.open(file), options)
          [content, $?.success?]
        end

        def process_compile_result(content, file, directory, errors, success)
          if success
            FileUtils.mkdir_p(File.expand_path(directory)) if !File.directory?(directory)
            filename = File.join(directory, File.basename(file.gsub(/coffee$/, 'js')))
            File.open(File.expand_path(filename), 'w') { |f| f.write(content) }

            filename
          else
            errors << file + ': ' + content.split("\n").select { |line| line =~ /^Error:/i }.join("\n")
            ::Guard::UI.error(content)

            nil
          end
        end

        def detect_nested_directories(watchers, files, options)
          return { options[:output] => files } if options[:shallow]

          directories = {}

          watchers.product(files).each do |watcher, file|
            if matches = file.match(watcher.pattern)
              target = File.join(options[:output], File.dirname(matches[1])).gsub(/\/\.$/, '')
              if directories[target]
                directories[target] << file
              else
                directories[target] = [file]
              end
            end
          end

          directories
        end

        def notify_result(changed_files, errors)
          if errors.empty?
            message = "Successfully generated #{ changed_files.join(', ') }"
            ::Guard::Notifier.notify(message, :title => 'CoffeeScript results')
          else
            ::Guard::Notifier.notify(errors.join("\n"), :title => 'CoffeeScript results', :image => :failed)
          end
        end

      end
    end
  end
end