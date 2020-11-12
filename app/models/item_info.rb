# frozen_string_literal: true

class ItemInfo < ApplicationRecord
  extend Enumerize
  self.table_name = 'item_info'

  belongs_to :item_request, optional: true, foreign_key: 'item_request_id'

  PARAMS_ATTRIBUTES = %i[
    id SKU info_sku name info_name category1
    category2 category3 info_category expected_sales_volume
    info_expected_sales_volume lead_time info_lead_time
    creator updater cost item_unit
  ].freeze

  ITEM_UNITS = { "コ": 'ko', "ホン": 'hon', "マイ": 'mai',
                 "メートル": 'meter', "タン": 'tan', "ソク": 'soku',
                 "タバ": 'taba', "クミ": 'miku', "セット": 'set' }.freeze

  enumerize :item_units, in: ITEM_UNITS, predicates: { predix: true }

  validates :SKU, :category1, :name, :cost, :expected_sales_volume, :lead_time, :item_unit, presence: true
  validates :SKU, uniqueness: true
end
