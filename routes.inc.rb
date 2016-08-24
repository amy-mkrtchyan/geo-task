require_relative 'lib/serializer.rb'

Dir['app/{routes,serializers}/*.rb'].each do |file|
  require_relative file
end
