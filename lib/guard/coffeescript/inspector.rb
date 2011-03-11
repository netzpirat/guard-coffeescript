module Guard
  class CoffeeScript
    module Inspector
      class << self

        def clean(paths)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| coffee_file?(p) }
          clear_coffee_files_list
          paths
        end

      private

        def coffee_file?(path)
          coffee_files.include?(path)
        end

        def coffee_files
          @coffee_files ||= Dir.glob('**/*.coffee')
        end

        def clear_coffee_files_list
          @coffee_files = nil
        end

      end
    end
  end
end
