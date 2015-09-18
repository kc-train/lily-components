module LilyComponents
  module Rails
    class Engine < ::Rails::Engine
      initializer 'lily-components.assets.precompile' do |app|
        %w(stylesheets javascripts fonts images).each do |sub|
          app.config.assets.paths << root.join('assets', sub).to_s
        end
        app.config.assets.precompile << %r(.*\.(?:eot|svg|ttf|woff2?)$)
      end
    end
  end
end