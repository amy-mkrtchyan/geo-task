require_relative 'lib/serializer.rb'

Dir['app/*/*.rb'].each do |file|
  require_relative file
end

require_relative 'db/seeds.rb'
