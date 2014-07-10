class Home < ActiveRecord::Base
  validates :home, :presence > true
end