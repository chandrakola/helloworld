require 'rails'
require 'action_controller/railtie'

module HelloWorld
  class Application < Rails::Application
    config.secret_key_base = "secure_key_base"
    config.eager_load = false
    config.logger = Logger.new(STDOUT)
    config.hosts << "example.org"
    
    routes.append do
      root to: 'welcome#index'
    end
  end
end
