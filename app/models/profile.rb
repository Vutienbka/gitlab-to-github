class Profile < ApplicationRecord
  acts_as_paranoid

  def full_name
    "#{first_name} #{last_name}"
  end
end