class Guest < ActiveRecord::Base
  attr_accessible :name, :url

  has_many :Episode

  validates :name, presence: true, :length => { :maximum => 255 }, uniqueness: { case_sensitive: false }

  validates :url, :length => { :maximum => 255 }
end
