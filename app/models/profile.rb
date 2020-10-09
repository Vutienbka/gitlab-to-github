class Profile < ApplicationRecord
  acts_as_paranoid
  def full_name
    "#{first_name} #{last_name}"
  end
  scope :filter_by_full_name, ->(query) { where("CONCAT_WS(' ', first_name, last_name) LIKE ?", "%#{query}%") }
end