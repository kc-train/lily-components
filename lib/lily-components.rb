require "lily-components/version"

module LilyComponents
  class << self
    def load!
      if rails?
        register_rails_engine
      end
    end

    def register_rails_engine
      require 'lily-components/engine'
    end

    def rails?
      defined?(::Rails)
    end
  end
end

LilyComponents.load!