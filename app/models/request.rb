class Request < ApplicationRecord
  acts_as_paranoid
  extend Enumerize

  has_many :item_requests, dependent: :destroy
  belongs_to :buyer
end
