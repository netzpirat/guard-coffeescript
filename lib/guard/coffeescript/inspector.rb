module Guard
  class CoffeeScript

    # The inspector verifies of the changed paths are valid
    # for Guard::CoffeeScript.
    #
    module Inspector
      class << self

        # Clean the changed paths and return only valid
        # CoffeeScript files.
        #
        # @param [Array<String>] paths the changed paths
        # @return [Array<String>] the valid spec files
        #
        def clean(paths)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| coffee_file?(p) }
          clear_coffee_files_list
          paths
        end

        private

        # Tests if the file is valid.
        #
        # @param [String] file the file
        # @return [Boolean] when the file valid
        #
        def coffee_file?(path)
          coffee_files.include?(path)
        end

        # Scans the project and keeps a list of all
        # CoffeeScript files.
        #
        # @see #clear_coffee_files_list
        # @return [Array<String>] the valid files
        #
        def coffee_files
          @coffee_files ||= Dir.glob('**/*.coffee')
        end

        # Clears the list of CoffeeScript files in this project.
        #
        def clear_coffee_files_list
          @coffee_files = nil
        end

      end
    end
  end
end
