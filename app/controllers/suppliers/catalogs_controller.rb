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

end