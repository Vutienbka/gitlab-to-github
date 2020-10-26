class Buyers::SearchsController < Buyers::BaseController
  def index
    if params[:q].blank?
      @q = ItemRequest.ransack(params[:q])
      @item_requests = @q.result.page(params[:page]).per 10
    else
      item_sku_id = ItemRequest.joins(:item_info).where("item_info.SKU like ?", "%#{params[:q][:status_cont]}%").ids
      item_name_id = ItemRequest.joins(:item_info).where("item_info.name like ?", "%#{params[:q][:status_cont]}%").ids
      catalog_id = ItemRequest.includes(:catalog).where(catalog_id: Catalog.where("name like ? ", "%#{params[:q][:status_cont]}%").ids).ids
      supplier_id = ItemRequest.where(supplier_id: Profile.where("first_name like ? ", "%#{params[:q][:status_cont]}%").ids).ids
      ids = item_sku_id + item_name_id + catalog_id + supplier_id
      @item_requests = ItemRequest.where(id: ids, status: 7).where.not(catalog_id: nil).includes([:item_info])

      @q = @item_requests.ransack.result.page(params[:page]).per 10
      render :search unless @item_requests.nil?
    end
  end

  def search; end

  def list_auto
    if params[:q].blank?
      @q = ItemRequest.ransack(params[:q])
      @item_requests = @q.result.page(params[:page]).per 10
    else
      item_sku_id = ItemRequest.joins(:item_info).where("item_info.SKU like ?", "%#{params[:q]}%").ids
      item_name_id = ItemRequest.joins(:item_info).where("item_info.name like ?", "%#{params[:q]}%").ids
      catalog_id = ItemRequest.includes(:catalog).where(catalog_id: Catalog.where("name like ? ", "%#{params[:q]}%").ids).ids
      supplier_id = ItemRequest.where(supplier_id: Profile.where("first_name like ? ", "%#{params[:q]}%").ids).ids
      ids = item_sku_id + item_name_id + catalog_id + supplier_id
      @item_requests = ItemRequest.where(id: ids).includes([:item_info])
      q = []
      @item_requests.each do |it|
        q << it.item_info
      end
    end
    @q = [] if @q.blank?
    render json: q
  end

  def claim_suggest_search
    unless params[:q].blank?
      item_sku_ids = Claims.joins(:item_request).where(item_request_id: (ItemRequest.joins(:item_info).where("item_info.SKU like ?", "%#{params[:q]}%").ids)).ids
      item_name_ids = Claims.joins(:item_request).where(item_request_id: (ItemRequest.joins(:item_info).where("item_info.name like ?", "%#{params[:q]}%").ids)).ids
      claim_lot_number_ids = Claims.where("lot_number like ?", "%#{params[:q]}%").ids
      claim_supplier_name_ids = Claims.where(supplier_id: Profile.where("company_name like ?", "%#{params[:q]}%").ids).ids
      ids = item_sku_ids + item_name_ids + claim_lot_number_ids + claim_supplier_name_ids
      
      if params[:item_code].blank? || (params[:item_code].eql? "blank")
        @claims = Claims.where(id: ids)
      else
        @item_info = ItemInfo.find_by(SKU: params[:item_code])
        @item_request = @item_info&.item_request
        @claims = @item_request&.claims.where(id: ids)
      end
      result = []
      @claims.each_with_index do |claim, index|
        q = []
        q << claim.id
        q << claim.lot_number
        q << claim.item_request.item_info.SKU
        q << claim.item_request.item_info.name
        q << claim.supplier.profile.company_name
        result.push(q)
      end 
    end
    respond_to do |format|
      format.json { render json: result }
    end
  end
end
