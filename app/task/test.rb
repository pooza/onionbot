desc 'test all'
task :test do
  ENV['TEST'] = Onionbot::Package.name
  require 'test/unit'
  Dir.glob(File.join(Onionbot::Environment.dir, 'test/*.rb')).each do |t|
    require t
  end
end
