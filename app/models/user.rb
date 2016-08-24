class User
  include Mongoid::Document
  include Mongoid::Geospatial
  include ActiveModel::SecurePassword

  TYPE = {
      MANAGER: 0,
      DRIVER: 1
  }

  SHOWABLE_FIELDS = %i{name type location}

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
    @current
  end

  def among?(*types)
    types.flatten!
    types.include?(TYPE.key(type).downcase)
  end

  def serialize
    to_json({include: :tasks, only: SHOWABLE_FIELDS})
  end
end



class Manager < User
  has_many :tasks, inverse_of: :manager
  default_scope ->{ where(type: User::TYPE[:MANAGER]) }
end



class Driver < User
  field :location, type: Point, spatial: true, delegate: true
  has_many :tasks, inverse_of: :driver
  default_scope ->{ where(type: User::TYPE[:DRIVER]) }
end
