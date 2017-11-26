#!/usr/bin/env ruby

path = File.expand_path(__FILE__)
while File.symlink?(path)
  path = File.expand_path(File.readlink(path))
end
ROOT_DIR = File.expand_path('..', path)
$LOAD_PATH.push(File.join(ROOT_DIR, 'lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(ROOT_DIR, 'Gemfile')

require 'bundler/setup'
require 'onionbot/application'

OnionBot::Application.new.execute
