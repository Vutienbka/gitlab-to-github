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

  def send_mail_inspection_request(inspection_request, supplier_profile, buyer)
    @inspect_company_name = inspection_request.inspect_company_name
    @inspect_address = inspection_request.inspect_address
    @inspect_tel = inspection_request.inspect_tel
    @supplier = User.find_by(id: supplier_profile.supplier_id)
    @buyer = buyer
    mail(
      to: @supplier.email,
      subject: "#{@buyer.profile&.company_name}社の#{@buyer.profile&.last_name}様から調達購買システム「NEWJI」の信用調査依頼メール"
    )
  end

  def send_mail_after_buyer_regiter(buyer)
    @buyer = buyer
    mail(
      to: @buyer.email,
      subject: t('devise.mailer.confirmation_instructions.subject')
    )
  end
end
