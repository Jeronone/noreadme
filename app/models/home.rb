class Home < ActiveRecord::Base
  validates :vid, :presence > true
end