class Buyers::SearchsController < Buyers::BaseController
  include StaticData
  before_action :get_claims, only: %i[claim_suggest_search]
  before_action :get_samples, only: %i[sample_suggest_search]
  before_action :item_requests, only: %i[sample_suggest_search]
  def index
    if params[:q].blank?
      @q = ItemRequest.ransack(params[:q])
      @item_requests = @q.result.page(params[:page]).per ITEM_PER_PAGE
    else
      item_sku_id = ItemRequest.joins(:item_info).where("item_info.SKU like ?", "%#{params[:q][:status_cont]}%").ids
      item_name_id = ItemRequest.joins(:item_info).where("item_info.name like ?", "%#{params[:q][:status_cont]}%").ids
      catalog_id = ItemRequest.includes(:catalog).where(catalog_id: Catalog.where("name like ? ", "%#{params[:q][:status_cont]}%").ids).ids
      supplier_id = ItemRequest.where(supplier_id: Profile.where("first_name like ? ", "%#{params[:q][:status_cont]}%").ids).ids
      ids = item_sku_id + item_name_id + catalog_id + supplier_id
      @item_requests = ItemRequest.where(id: ids, status: 7).where.not(catalog_id: nil).includes([:item_info])

      @q = @item_requests.ransack.result.page(params[:page]).per ITEM_PER_PAGE
      render :search unless @item_requests.nil?
    end
  end

  def search; end

  def list_auto
    if params[:q].blank?
      @q = ItemRequest.ransack(params[:q])
      @item_requests = @q.result.page(params[:page]).per ITEM_PER_PAGE
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
      item_sku_ids = @claims.joins(:item_request).where(item_request_id: (ItemRequest.joins(:item_info).where("item_info.SKU like ?", "%#{params[:q]}%").ids)).ids
      item_name_ids = @claims.joins(:item_request).where(item_request_id: (ItemRequest.joins(:item_info).where("item_info.name like ?", "%#{params[:q]}%").ids)).ids
      claim_lot_number_ids = @claims.where("lot_number like ?", "%#{params[:q]}%").ids
      claim_supplier_name_ids = @claims.where(supplier_id: Profile.where("company_name like ?", "%#{params[:q]}%").ids).ids
      ids = item_sku_ids + item_name_ids + claim_lot_number_ids + claim_supplier_name_ids
      
      if params[:item_code].blank? || (params[:item_code].eql? 'blank')
        @claims = @claims.where(id: ids)
      else
        @item_info = ItemInfo.find_by(SKU: params[:item_code])
        @item_request = @item_info&.item_request
        @claims = @item_request&.claims.where(buyer_id: current_user.id).where(id: ids)
      end
      result = []
      @claims.each do |claim|
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

  def sample_suggest_search
    unless params[:q].blank?
      supplier_name_or_code_ids = @samples.search_by_supplier_name_or_code(@item_requests, params[:q]).ids
      sample_title_or_code_ids = @samples.search_by_sample_title_or_code(@samples, params[:q]).ids
      catalog_name_ids = @samples.search_by_catalog_name(@item_requests, params[:q]).ids
      sample_ids = supplier_name_or_code_ids + sample_title_or_code_ids + catalog_name_ids
      @samples = @samples.where(id: sample_ids)
      result = []
      @samples.each do |sample|
        q = []
        q << sample.id
        q << sample.title
        q << sample.code
        q << sample.item_request.item_info.SKU
        q << sample.item_request.item_info.name
        q << sample.item_request.supplier.profile.company_name
        result.push(q)
      end 
    end
    respond_to do |format|
      format.json { render json: result }
    end
  end

  private
  
  def get_claims
    @claims = current_user.claims
  end
  def get_samples
    @samples = current_user.samples
  end

  def item_requests
    @item_requests = current_user.item_requests
  end
end
