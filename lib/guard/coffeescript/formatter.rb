module Guard
  class CoffeeScript
    module Formatter
      class << self

        def info(message, options={})
          ::Guard::UI.info(message, options)
        end

        def debug(message, options={})
          ::Guard::UI.debug(message, options)
        end

        def error(message, options={})
          ::Guard::UI.error(::Guard::UI.send(:color, message, "\e[31m"), options)
        end

        def success(message, options={})
          ::Guard::UI.info(::Guard::UI.send(:color, message, "\e[32m"), options)
        end

        def notify(message, options={})
          ::Guard::Notifier.notify(message, options)
        end

      end
    end
  end
end
