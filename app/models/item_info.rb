class ItemInfo < ApplicationRecord
  acts_as_paranoid
  self.table_name = 'item_info'

  belongs_to :item_request, optional: true

  PARAMS_ATTRIBUTES = [
    :id, :SKU, :info_sku, :name, :info_name, :category1,
    :category2, :category3, :info_category, :expected_sales_volume,
    :info_expected_sales_volume, :lead_time, :info_lead_time,
    :creator, :updater, :cost
  ]

  validates :SKU, :category1, :name, :cost, :expected_sales_volume, :lead_time, presence: true
end
