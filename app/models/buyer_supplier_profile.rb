class BuyerSupplierProfile < Profile
  belongs_to :buyer_supplier

  validates :last_name, :first_name, :company_name, :department, :position, presence: true
end