class Buyer < User
  has_one :profile, class_name: 'BuyerProfile', dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :inspection_requests

  accepts_nested_attributes_for :profile

  before_create :set_token
  after_create :send_mail_after_sign_up

  def set_token
    self.token = SecureRandom.hex
  end

  def send_mail_after_sign_up
    BuyerMailer.send_mail_after_buyer_regiter(self).deliver_now
  end
end

