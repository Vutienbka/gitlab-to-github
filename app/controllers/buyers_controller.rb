class BuyersController < UsersController
  def invite_unregisted_supplier
  end

  def send_email_invite
    buyer = current_user
    return redirect_to root_path, flash: {success: 'サプライヤーのご登録をお待ちください'} if BuyerMailer.send_mail_invite_unregisted_supplier(params, buyer).deliver_now
  end


  def search_provider
    @search = Supplier.ransack({ profile_company_name_or_profile_code_cont: params[:search] })
    @search_suppliers = @search.result
    # binding.pry
  end

end