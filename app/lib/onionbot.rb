require 'active_support'
require 'active_support/core_ext'
require 'zeitwerk'
require 'ginseng'

module Onionbot
  def self.dir
    return File.expand_path('../..', __dir__)
  end

  def self.loader
    loader = Zeitwerk::Loader.new
    loader.inflector.inflect(
      'http' => 'HTTP',
    )
    loader.push_dir(File.join(dir, 'app/lib'))
    loader.setup
  end
end

Onionbot.loader
