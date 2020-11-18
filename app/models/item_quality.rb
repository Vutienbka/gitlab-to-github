# frozen_string_literal: true

class ItemQuality < ApplicationRecord
  belongs_to :item_request, optional: true

  PARAMS_ATTRIBUTES = %i[
    id item_request
    quality1 quality2 quality3 quality4
    quality5 quality6 quality7 quality8
    quality9 quality10 quality11 quality12
    quality13 quality14 quality15 quality16
    info1 info2 info3 info4 info5 info6
    info7 info8 info9 info10 info11 info12
    info13 info14 info15 info16
  ].freeze
end
