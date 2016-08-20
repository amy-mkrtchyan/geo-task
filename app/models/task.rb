class Task
  include Mongoid::Document
  include Mongoid::Geospatial
  include Mongoid::Timestamps

  STATE_NEW = 1
  STATE_ASSIGNED = 2
  STATE_DONE = 3

  belongs_to :manager, index: true
  belongs_to :driver, index: true

  field :name, type: String
  field :state, type: Integer, default: STATE_NEW
  field :location, type: Point

  def id
    _id.to_s
  end

  def manager_name
    manager.try(:name)
  end

  def driver_name
    driver.try(:name)
  end

end
