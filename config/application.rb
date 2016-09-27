require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ImCore
  class Application < Rails::Application
    ### 各种猴子补丁
    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    ### browserify coffee 引用
    config.browserify_rails.commandline_options = "-t coffee-reactify --extension='.coffee'"
  end
end
