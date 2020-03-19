class Request < ApplicationRecord
  acts_as_paranoid
  extend Enumerize

  has_many :item_requests, dependent: :destroy
  belongs_to :buyer

  REQUEST_STATUSES = {
    'information': 1,
    'draw': 2,
    'image': 3,
    'quality': 4,
    'standard': 5,
    'condition': 6,
    'sample': 7,
    'estimate': 8,
    'low_cost': 9
  }

  enumerize :request_status, in: REQUEST_STATUSES, predicates: { prefix: true }
end
