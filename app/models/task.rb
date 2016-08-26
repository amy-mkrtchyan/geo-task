class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include Mongoid::Validatable


  @@lng_symbols <<:x0 << :x1
  @@lat_symbols <<:y0 << :y1

  STATE_NEW = 1
  STATE_ASSIGNED = 2
  STATE_DONE = 3

  belongs_to :manager, index: true, foreign_key: :manager_id
  belongs_to :driver, index: true, foreign_key: :driver_id

  field :name, type: String
  field :state, type: Integer, default: -> { has_driver? ? STATE_ASSIGNED : STATE_NEW }
  field :pickup, type: Point, sphere: true, delegate: {x: :x0, y: :y0}
  field :delivery, type: Point, spatial: true, delegate: {x: :x1, y: :y1}

  index({ name: 1 }, { unique: true })

  validates_presence_of :name

  spatial_scope :pickup

  scope :unassigned, -> { where(state: STATE_NEW)}
  scope :assigned, -> { where(state: STATE_ASSIGNED)}
  scope :done, -> { where(state: STATE_DONE)}

  def id
    _id.to_s
  end

  def manager_name
    manager.try(:name)
  end

  def driver_name
    driver.try(:name)
  end

  def assign_to(user)
    update!(driver: user, state: STATE_ASSIGNED)
  end

  def unpick!
    update!(driver: nil, state: STATE_NEW)
  end

  def deliver!
    update!(state: STATE_DONE)
    driver.update!(location: delivery)
  end

end
