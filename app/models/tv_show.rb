class TvShow < ActiveRecord::Base
  attr_accessible :name, :identifier, :url

  has_many :episodes

  before_save {
    self.identifier = identifier.downcase
  }

  validates :name, presence: true, :length => { :maximum => 255 }, uniqueness: { case_sensitive: false }
  validates :identifier, :length => { :maximum => 255 }
  validates :url, :length => { :maximum => 255 }
end
