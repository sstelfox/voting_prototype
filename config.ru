base_directory = File.expand_path(File.dirname(__FILE__))
$:.unshift(base_directory) unless $:.include?(base_directory)

require 'voting'

# Workaround for the annoying thin bug that prevents it from closing on a
# Ctrl-C
trap('INT') { exit }

warmup do |app|
  client = Rack::MockRequest.new(app)
  client.get('/')
  puts 'Warmed up!'
end

puts DataMapper::Repository.adapters[:default].instance_variable_get(:'@normalized_uri').path

run Voting::App
