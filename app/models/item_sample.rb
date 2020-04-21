class ItemSample < ApplicationRecord
  acts_as_paranoid
  belongs_to :item_request

  PARAMS_ATTRIBUTES = %i[
    id item_request
    sample_category1_id category_type1 sample_category2_id category_type2
    sample_category3_id category_type3 sample_category4_id category_type4
  ].freeze
end
