class User < ActiveRecord::Base
  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods
  has_many :characters
  has_many :parties, :through => :characters
  has_secure_password
end
