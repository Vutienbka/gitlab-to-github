class Buyers::SearchsController < Buyers::BaseController
  def index
    if params[:q].blank?
      @q = ItemRequest.ransack(params[:q])
      @item_requests = @q.result.page(params[:page]).per 10
    else
      item_sku_id = ItemRequest.joins(:item_info).where('item_info.SKU like ?', "%#{params[:q][:status_cont]}%").ids
      item_name_id = ItemRequest.joins(:item_info).where('item_info.name like ?', "%#{params[:q][:status_cont]}%").ids
      catalog_id = ItemRequest.includes(:catalog).where(catalog_id: Catalog.where("name like ? ", "%#{params[:q][:status_cont]}%").ids).ids
      supplier_id = ItemRequest.where(supplier_id: Profile.where('first_name like ? ', "%#{params[:q][:status_cont]}%").ids).ids
      ids = item_sku_id + item_name_id + catalog_id + supplier_id
      @item_requests = ItemRequest.where(id: ids).includes([:item_info])

      @q = @item_requests.ransack.result.page(params[:page]).per 10
      render :search unless @item_requests.nil?
    end
  end

  def search
  end

  def list_auto
    # @item_info = ItemInfo.ransack(params[:q])
    # render json: @item_info.result
    # + item_name_id + catalog_id + supplier_id
    if params[:q].blank?
      @q = ItemRequest.ransack(params[:q])
      @item_requests = @q.result.page(params[:page]).per 10
    else
      item_sku_id = ItemRequest.joins(:item_info).where('item_info.SKU like ?', "%#{params[:q]}%").ids
      item_name_id = ItemRequest.joins(:item_info).where('item_info.name like ?', "%#{params[:q]}%").ids
      catalog_id = ItemRequest.includes(:catalog).where(catalog_id: Catalog.where("name like ? ", "%#{params[:q]}%").ids).ids
      supplier_id = ItemRequest.where(supplier_id: Profile.where('first_name like ? ', "%#{params[:q]}%").ids).ids
      ids = item_sku_id + item_name_id + catalog_id + supplier_id
      @item_requests = ItemRequest.where(id: ids).includes([:item_info])
      q= []
      # @q = @item_requests.ransack.result.page(params[:page]).per 10
      @item_requests.each do |it|
        q << it.item_info
      end
    end
    if @q.blank?
      @q = []
    end
    render json: q
  end
end
