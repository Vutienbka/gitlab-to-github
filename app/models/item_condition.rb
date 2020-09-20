class ItemCondition < ApplicationRecord
  belongs_to :item_request, optional: true
end
