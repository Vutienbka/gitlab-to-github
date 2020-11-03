class Claim < ApplicationRecord
  extend Enumerize
  acts_as_paranoid
  mount_uploaders :claims_image, ImageUploader
  serialize :claims_image, JSON
  serialize :classify, JSON

  belongs_to :item_request, optional: true, foreign_key: 'item_request_id'
  belongs_to :supplier, optional: true, foreign_key: 'supplier_id'
  belongs_to :buyer, class_name: 'Buyer', optional: true, foreign_key: 'buyer_id'

  PARAMS_ATTRIBUTES = [
    :item_request_id, { classify: [] }, :claim_content, :lot_number,
    { claims_image: [] }
  ].freeze

  CLASSIFY = [
   'uncategorized',
   'mixed_with_foreign_matter',
   'scratches',
   'poor_shape',
   'poor_color',
   'wrong_color',
   'rust',
   'wrong_table',
   'insufficient_quantity',
   'exterior_crack',
   'interior_crack',
   'wrong_design',
   'missing_part',
   'shortage_of_part',
   'wrong_quanlity',
   'misassembly'
  ]

  REASON_COUNTER_PLANS = ['cause_unanswered', 'counterplan_unanswered', 'cause_answered', 'counterplan_answered']

  REASON_STATUS = {
    "未回答": 0,
    "回答済み": 1,
  }.freeze
  enumerize :reason_status, in: REASON_STATUS, predicates: { predix: true }

  COUNTER_PLAN_STATUS = {
    "未回答": 0,
    "回答済み": 1
  }.freeze
  enumerize :counter_plan_status, in: COUNTER_PLAN_STATUS, predicates: { predix: true }

  scope :filter_by_date_range, ->(period_from, period_to){ where("STR_TO_DATE(created_at, '%Y-%m-%d') BETWEEN ? AND ?",period_from, period_to) if (period_from.present? && period_to.present?) }
  scope :filter_by_counter_plan_status, -> (counter_plan_status){ where(:counter_plan_status => counter_plan_status) if counter_plan_status.present?}
  scope :filter_by_reason_status, -> (reason_status){ where(:reason_status => reason_status) if reason_status.present?}
  scope :filter_by_classify, -> (classify){ where(:classify => ['join('') like ?', "%#{classify}%"]) if classify.present?}
end
