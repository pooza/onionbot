require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies/autoload'

module Onionbot
  extend ActiveSupport::Autoload

  autoload :Application
  autoload :Chinachu
  autoload :Config
  autoload :DataFile
  autoload :Environment
  autoload :Error
  autoload :Logger
  autoload :Package
  autoload :Slack

  autoload_under 'error' do
    autoload :ConfigError
  end
end
