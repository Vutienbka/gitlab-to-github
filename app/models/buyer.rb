class Buyer < User
  has_one :profile, class_name: 'BuyerProfile', dependent: :destroy

  accepts_nested_attributes_for :profile
end