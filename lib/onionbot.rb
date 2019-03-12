require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies/autoload'
require 'ginseng'

module Onionbot
  extend ActiveSupport::Autoload

  autoload :Chinachu
  autoload :Config
  autoload :Crawler
  autoload :DataFile
  autoload :Environment
  autoload :HTTP
  autoload :Logger
  autoload :Package
  autoload :Slack
end
