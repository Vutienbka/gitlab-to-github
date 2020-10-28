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

  CLASSIFY = {
    "未分類": 0,
    "異物混入": 1,
    "キズ": 2,
    "形状不良": 3,
    "色調不良（色違い）": 4,
    "色調不良（色目違い）": 5,
    "サビ": 6,
    "ラベル違い": 7,
    "数量不足": 8,
    "外装割れ": 9,
    "外装破損": 10,
    "意匠違い": 11,
    "部品欠落": 12,
    "部品不足": 13,
    "数量違い": 14,
    "組み間違い": 15
  }.freeze
  enumerize :classifies, in: CLASSIFY, predicates: { predix: true }

  REASON_COUNTER_PLAN = {
    "原因未回答": '原因未回答',
    "対策未回答": '対策未回答',
    "原因回答済み": '原因回答済み​',
    "対策回答済み": '対策回答済み'
  }.freeze
  enumerize :reason_counter_plans, in: REASON_COUNTER_PLAN, predicates: { predix: true }

  REASON_STATUS = {
    "未回答": 0,
    "回答済み": 1
  }.freeze
  enumerize :reason_status, in: REASON_STATUS, predicates: { predix: true }
  COUNTER_PLAN_STATUS = {
    "未回答": 0,
    "回答済み": 1
  }.freeze
  enumerize :counter_plan_status, in: COUNTER_PLAN_STATUS, predicates: { predix: true }

  SELECTION = {
    "未回答": '未回答',
    "回答済み​": '回答済み​'
  }.freeze
  enumerize :selections, in: SELECTION, predicates: { predix: true }

  scope :filter_by_date_range, ->(period_from, period_to){ where("STR_TO_DATE(created_at, '%Y-%m-%d') BETWEEN ? AND ?",period_from, period_to) if (period_from.present? && period_to.present?) }
  scope :filter_by_counter_plan_status, -> (counter_plan_status){ where(:counter_plan_status => counter_plan_status) if counter_plan_status.present?}
  scope :filter_by_reason_status, -> (reason_status){ where(:reason_status => reason_status) if reason_status.present?}
  scope :filter_by_classify, -> (classify){ where(:classify => ['join('') like ?', "%#{classify}%"]) if classify.present?}
end
