class Score < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :picture
  has_and_belongs_to_many :locations

  scope :finished, -> { where(finished: true) }
  scope :unfinished, -> { where(finished: false) }

  def owned?
    !self.user.nil?
  end

  def active?
    !self.last_active.nil?
  end

  def total_time
    (self.elapsed_time + (DateTime.now.getutc - (self.last_active || DateTime.now.getutc))).to_i
  end

  def update_time
    if self.active?
      self.update(last_active: DateTime.now.getutc, elapsed_time: self.total_time)
    else
      self.update(last_active: DateTime.now.getutc)
    end
  end

  def add_time
    if self.active?
      self.update(last_active: nil, elapsed_time: self.total_time)
    end
  end

  def finish
    if (self.locations == self.picture.locations)
      self.add_time
      self.update(finished: true)
      true
    else
      false
    end
  end

end
