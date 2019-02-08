require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies/autoload'
require 'ginseng'

module Onionbot
  extend ActiveSupport::Autoload

  autoload :Application
  autoload :Chinachu
  autoload :Config
  autoload :DataFile
  autoload :Environment
  autoload :Logger
  autoload :Package
  autoload :Slack
end
