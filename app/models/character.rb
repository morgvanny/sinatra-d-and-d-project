class Character < ActiveRecord::Base
  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods
  belongs_to :user
  belongs_to :party
end
