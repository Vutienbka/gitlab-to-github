class Buyers::ListBuyerSuppliersController < Buyers::BaseController
  def index
    @item_requests = current_user.item_requests.includes([:item_info]) 
    @user_update = Buyer.includes(:profile).index_by(&:id)
    @suppliers = Supplier.where(id: current_user.item_requests.pluck(:supplier_id))
                  .where(id: Profile.filter_by_full_name(params[:search]).pluck(:supplier_id)) 
    @search_name = @suppliers.page(params[:page]).per(20)
  end
end