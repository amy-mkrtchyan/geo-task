class User
  include Mongoid::Document
  include Mongoid::Geospatial
  include ActiveModel::SecurePassword

  TYPE = {
      MANAGER: 0,
      DRIVER: 1
  }

  has_secure_password

  field :name, type: String
  field :login, type: String
  field :password_digest, type: String
  field :token, type: String
  field :type, type: Integer, default: TYPE[:DRIVER]

  validates_presence_of :name, :login
  validates_uniqueness_of :login

  def generate_token!
    update_attribute(:token, SecureRandom.urlsafe_base64(64))
  end

  def among?(*types)
    types.flatten!
    types.include?(self.name.downcase.to_sym)
  end
end



class Manager < User
  has_many :tasks, inverse_of: :manager
  default_scope ->{ where(type: User::TYPE[:MANAGER]) }
end



class Driver < User
  field :location, type: Point, spatial: true, delegate: {x: :x, y: :y}
  has_many :tasks, inverse_of: :driver
  default_scope ->{ where(type: User::TYPE[:DRIVER]) }

  validate :driver_location

  def busy?
    tasks.any? {|t| t.state == Task::STATE_ASSIGNED }
  end

private

  def driver_location
    errors.add(:location, 'is invalid!') unless x && y && x.is_a?(Numeric) && y.is_a?(Numeric)
  end
end
