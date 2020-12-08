class Suppliers::CatalogsController < Suppliers::BaseController
  
  def index
    @q = Profile.where(buyer_id: current_user.item_request.pluck(:buyer_id).uniq).order('id DESC').ransack(params[:q])
    @item_info = @q.result.page(params[:page])

    @list_buyers = Profile.where(buyer_id: current_user.item_request.pluck(:buyer_id).uniq).order('id DESC')
    session[:link_index] = request.original_url
  end

  def parents
    @q = ItemInfo.where(item_request_id: current_user.item_request.ids).ransack(params[:q])
    @item_info = @q.result.page(params[:page])
    @catalogs_parents = Catalog.where(level_type: 'parent', buyer_id: params[:buyer_id])
    session[:link_parents_catalog] = request.original_url
    session[:buyer_id] = params[:buyer_id]
  end

  def sub_catalogs
    @q = ItemInfo.where(item_request_id: current_user.item_request.ids).ransack(params[:q])
    @item_info = @q.result.page(params[:page])
    @catalogs_sub = Catalog.where(level_type: 'sub_catalog', parent_catalog_id: params[:parent_catalog_id])
    session[:parent_catalog_id] = params[:parent_catalog_id]
    session[:link_sub_catalog] = request.original_url
  end

  def grandchildren_catalogs
    @q = ItemInfo.where(item_request_id: current_user.item_request.ids).ransack(params[:q])
    @item_info = @q.result.page(params[:page])
    @catalogs_grandchildren = Catalog.where(level_type: 'grandchild_catalog', parent_catalog_id: params[:sub_catalog_id])
    session[:sub_catalog_id] = params[:sub_catalog_id]
    session[:link_grandchildren_catalog] = request.original_url
  end

  def item_catalogs
    @q = ItemInfo.where(item_request_id: current_user.item_request.ids).ransack(params[:q])
    @item_info = @q.result.page(params[:page])
    session[:grandchildren_catalog_id] = params[:grandchildren_catalog_id]
    @item_catalogs = ItemRequest.where(catalog_id: session[:grandchildren_catalog_id])
  end

  def search
    @q = Profile.where(buyer_id: current_user.item_request.pluck(:buyer_id).uniq).order('id DESC').ransack(params[:q])
    @item_info = @q.result.page(params[:page])
  end

  def search_item_catalogs
    @q = ItemInfo.where(item_request_id: current_user.item_request.ids).ransack(params[:q])
    @item_info = @q.result.page(params[:page])
  end

  def search_auto
    @q = Profile.where(buyer_id: current_user.item_request.pluck(:buyer_id).uniq).order('id DESC').ransack(params[:q])
    render json: { profile: @q.result }
  end

  def search_item_catalogs_auto
    @q = ItemInfo.where(item_request_id: current_user.item_request.ids).ransack(params[:q])
    render json: { profile: @q.result }
  end

  def introduce
    @invite_buyer = InviteBuyer.new
  end

  def introduce_submit
    @url = request.base_url + invite_email_suppliers_catalogs_path
    @buyer = User.find_by_email(params.dig(:invite_buyer, :email_address))
    session[:email] = params.dig(:invite_buyer, :email_address)
    if @buyer.present?
      @email_invite = InviteBuyer.find_by_email_address(params.dig(:invite_buyer, :email_address))
      if @email_invite.present?
        flash[:alert] = I18n.t('email_already_exists.fail')
      else
        @invite_buyer = InviteBuyer.create(introduce_params)
        BuyerMailer.send_mail_after_buyer_regiter(@buyer, @url).deliver_now
        flash[:success] = I18n.t('send_email_invite.success')
      end
    else
      flash[:alert] = I18n.t('email_not_already.fail')
    end
    @invite_buyer = InviteBuyer.new(introduce_params)
    render :introduce
  end

  def invite_email
    @buyer = User.find_by_email(session[:email])
    @item_request = ItemRequest.new
    @item_request.supplier_id = current_user.id
    @item_request.buyer_id = @buyer.id
    if @item_request.save
      flash[:success] = I18n.t('invite_buyer.success')
    else
      flash[:alert] = I18n.t('invite_buyer.fail')
    end
    redirect_to suppliers_catalogs_path
  end

  private

  def introduce_params
    params.require(:invite_buyer).permit(InviteBuyer::PARAMS_ATTRIBUTES)
  end
end