class Episode < ActiveRecord::Base
  attr_accessible :date, :guest_id, :tv_show_id

  belongs_to :tv_show
  belongs_to :guest

  validates :date, :date => { :before_or_equal_to => Date.today, :message => 'Date must not be in the future.' }
  validates :date, presence: true

  validates_uniqueness_of :date, :scope => [:tv_show_id, :guest_id]
end
