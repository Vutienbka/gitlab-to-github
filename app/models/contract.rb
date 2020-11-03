class Contract < ApplicationRecord
  mount_uploaders :contract_data, DrawUploader
  serialize :contract_data, JSON

  belongs_to :user, foreign_key: "user_id", optional: true

  PARAMS = [
    :contract_type, :contract_status, :contract_date,
    { contract_data: [] }
  ].freeze
end
