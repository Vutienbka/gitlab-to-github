class BuyersController < UsersController
  def invite_unregisted_supplier
  end

  def send_email_invite
    buyer = current_user
    return redirect_to root_path, flash: {success: 'サプライヤーのご登録をお待ちください'} if BuyerMailer.send_mail_invite_unregisted_supplier(params, buyer).deliver_now
  end
end