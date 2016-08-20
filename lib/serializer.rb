class Serializer
  attr_accessor :options, :resource

  def initialize(resource)
    self.resource = resource
  end

  def to_json
    opts = self.class::OPTIONS rescue {}
    resource.to_json(opts)
  end
end