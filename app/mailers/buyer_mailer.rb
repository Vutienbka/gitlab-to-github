class BuyerMailer < ActionMailer::Base
  default from: 'from@example.com'

  def send_mail_invite_unregisted_supplier(params, buyer)
    @supplier_email = params[:invite][:email]
    @supplier_company = params[:invite][:company]
    @buyer = buyer
    mail(
      to: @supplier_email,
      subject: "#{@buyer.profile&.company_name}社の#{@buyer.profile&.last_name}様から調達購買システム「NEWJI」のご招待メール"
    )
  end
end
