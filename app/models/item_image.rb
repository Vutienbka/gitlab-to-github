# frozen_string_literal: true

class ItemImage < ApplicationRecord
  belongs_to :item_request
  PARAMS_ATTRIBUTES = %i[
    id item_request_id
  ].freeze
end
