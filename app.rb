require_relative 'dependencies'

class GeoTask < Sinatra::Base

  Mongoid.load!('config/mongoid.yml', :development)

  before do
    begin
      content_type :json
      if request.body.read(1)
        request.body.rewind
        @request_payload = JSON.parse(request.body.read, { symbolize_names: true })
      end
    rescue JSON::ParserError => e
      request.body.rewind
      puts "The body #{request.body.read} was not JSON"
    end
  end

  require_relative 'mvc_components'

  before /^(?!\/(login|signup))/ do
    @current_user = User.where(token: env['HTTP_ACCESS_TOKEN']).first if env['HTTP_ACCESS_TOKEN']
    error(403, 'Access denied!') unless @current_user
  end

  set(:method) do |method|
    method = method.to_s.upcase
    condition { request.request_method == method }
  end
end
