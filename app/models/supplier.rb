class Supplier < User
  has_one :profile, class_name: 'SupplierProfile', dependent: :destroy

  accepts_nested_attributes_for :profile
end