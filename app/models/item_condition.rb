class ItemCondition < ApplicationRecord
  acts_as_paranoid
  belongs_to :item_request, optional: true
end
