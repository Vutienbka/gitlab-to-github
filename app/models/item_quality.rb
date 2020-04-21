# frozen_string_literal: true

class ItemQuality < ApplicationRecord
  acts_as_paranoid
  belongs_to :item_request

  PARAMS_ATTRIBUTES = %i[
    id item_request
    quality1 quality2 quality3 quality4
    quality5 quality6 quality7 quality8
    quality9 quality10 quality11 quality12
    quality13 quality14 quality15 quality16
  ].freeze
end
