class QuotationMailer < ApplicationMailer
  default from: "from@example.com"


  def send_maill_quotation_items(email, buyer)
    @email_supplier = email
    @buyer = buyer
    mail(
      to: @email_supplier,
      subject: "社の#{@buyer.profile&.company_name} 見積もりを送る"
    )
  end
end
