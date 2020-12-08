class InviteBuyer < ApplicationRecord
  belongs_to :item_request, optional: true

  PARAMS_ATTRIBUTES = [
    :item_requests_id, :email_address, :name
  ]
end
