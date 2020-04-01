class QuotationMailer < ApplicationMailer
  default from: "from@example.com"


  def send_maill_quotation_items(email, buyer)
    @email_supplier = email
    @buyer = buyer
    mail(
      to: @email_supplier.email,
      subject: "#{@buyer.profile&.company_name}社の#{@buyer.profile&.last_name}様から調達購買システム「NEWJI」のご見積依頼メール"
    )
  end
end
