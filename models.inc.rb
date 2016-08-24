Dir['app/{models}/*.rb'].each do |file|
  require_relative file
end

require_relative 'db/seeds.rb'
