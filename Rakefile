dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'onionbot'

[:crawl].each do |action|
  desc "alias of onion:#{action}"
  task action => "onion:#{action}"
end

Dir.glob(File.join(Onionbot::Environment.dir, 'lib/task/*.rb')).each do |f|
  require f
end
