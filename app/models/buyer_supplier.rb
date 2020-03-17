class BuyerSupplier < User
  has_one :profile, class_name: 'BuyerSupplierProfile', dependent: :destroy

  accepts_nested_attributes_for :profile
end