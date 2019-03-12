namespace :onion do
  desc 'crawl'
  task :crawl do
    sh File.join(Onionbot::Environment.dir, 'bin/crawl.rb')
  end
end
