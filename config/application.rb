require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestBe
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.before_configuration do
      if Rails.env.test?
        local_env_file_name = ENV["LOCAL_ENV_FILE"] || 'local_env.test.yml'
        local_env_file = File.join(Rails.root, 'config', local_env_file_name)
      else
        local_env_file_name = ENV["LOCAL_ENV_FILE"] || 'local_env.yml'
        local_env_file = File.join(Rails.root, 'config', local_env_file_name)
      end
      YAML.load(File.open(local_env_file)).each do |key, value|
        ENV[key.to_s] = value.to_s
      end if File.exists?(local_env_file)
    end

    config.generators.javascript_engine = :js
  end
end
