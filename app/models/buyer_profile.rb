class BuyerProfile < Profile
  belongs_to :buyer

  validates :last_name, :first_name, :company_name, :department, :position, presence: true
end