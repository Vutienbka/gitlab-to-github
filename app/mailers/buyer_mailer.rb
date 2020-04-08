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

  def send_mail_inspection_request(inspection_request, buyer)
    @inspect_company_name = inspection_request.inspect_company_name
    @inspect_address = inspection_request.inspect_address
    @inspect_tel = inspection_request.inspect_tel
    @buyer = buyer
    mail(
      to: 'newjisystem2020@gmail.com',
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

  def send_mail_after_supplier_invited_register(buyer, supplier)
    @buyer = buyer
    @supplier = supplier
    mail(
      to: @buyer.email,
      subject: "#{@supplier.profile&.company_name}社の#{@supplier.profile&.full_name}様から調達購買システム「NEWJI」のサプライヤー登録完了通知"
    )
  end
end
