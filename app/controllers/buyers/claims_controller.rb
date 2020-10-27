# frozen_string_literal: true

class Buyers::ClaimsController < Buyers::BaseController
  include StaticData
  before_action :redirect_to_profile, except: %i[list_claim]
  before_action :get_claims
  before_action :initialize_claim, only: %i[index new]

  def index; end

  def new; end

  def create
    @claim = Claims.new(claims_params)
    begin
      ActiveRecord::Base.transaction do
        @claim.save
        item_request = ItemInfo.find_by(SKU: params[:claim_item_code]).item_request
        @claim.update_attributes(item_request_id: item_request.id, supplier_id: item_request.supplier_id, buyer_id: current_user.id)
        return redirect_to buyers_claim_path(@claim), flash: { success: I18n.t("update.success") }
      end
    rescue StandardError
      flash[:alert] = I18n.t("create.failed")
      redirect_to buyers_claims_path
    end
  end

  def input; end

  def table
    if params[:q].blank?
      if params[:item_code].blank? || (params[:item_code] == "blank")
        @q = @claims.ransack(params[:q])
      else
        @item_info = ItemInfo.find_by(SKU: params[:item_code])
        @item_request = @item_info&.item_request
        @q = @item_request&.claims.where(buyer_id: current_user.id).ransack(params[:q])
      end
      @claims = @q.result.page(params[:page]).per ITEM_PER_PAGE
    end
  end

  def filter
    if params[:q].blank?
      if params[:item_code].blank? || (params[:item_code] == "blank")
        @q = @claims.ransack(params[:q])
        @claims = @q.result.page(params[:page]).per ITEM_PER_PAGE
      else
        @item_info = ItemInfo.find_by(SKU: params[:item_code])
        @item_request = @item_info&.item_request
        @q = @item_request&.claims.where(buyer_id: current_user.id).ransack(params[:q])
        @claims = @q.result
      end
      string_params = params[:claim][:reason_counter_plans]

      if string_params.include? "原因"
        selection_status = @claims.reason_status
        reason_match_string_index = check_match(string_params, selection_status)
      end

      if string_params.include? "対策"
        selection_status = @claims.counter_plan_status
        counter_plan_match_string_index = check_match(string_params, selection_status)
      end
      @claim_classify = @claims.classifies.find_value(params[:claim][:classify])
      @claim_classify_param = params[:claim][:classify]
      @q = @claims&.filter_by_date_range(params[:select_period_from]&.to_date, params[:select_period_to]&.to_date)
        .filter_by_reason_status(reason_match_string_index)
        .filter_by_counter_plan_status(counter_plan_match_string_index).ransack(params[:q])
      @claims = @q.result.page(params[:page]).per ITEM_PER_PAGE

      unless @claims.present?
        flash[:alert] = "見つからなかった"
        render :table
        return
      end
      render :table
    else
      redirect_to search_buyers_claims_path
    end
  end

  def search_with_ajax
    @q = @claims.where(id: params[:id]).ransack(params[:q])
    @claims = @q.result.page(params[:page]).per ITEM_PER_PAGE
    respond_to do |format|
      format.js { render json: { html: render_to_string(partial: "claim_table", locals: { claims: @claims }) } }
    end
  end

  def search_by_submit
    if params[:item_code].blank? || (params[:item_code] == "blank")
      @claims = @claims
    else
      @item_info = ItemInfo.find_by(SKU: params[:item_code])
      @item_request = @item_info&.item_request
      @claims = @item_request&.claims.where(buyer_id: current_user.id)
    end
    if params[:q][:lot_number_cont].blank?
      @q = @claims.ransack(params[:q][:lot_number_cont])
    else
      item_sku_ids = @claims.joins(:item_request).where(item_request_id: (ItemRequest.joins(:item_info).where("item_info.SKU like ?", "%#{params[:q][:lot_number_cont]}%").ids)).ids
      item_name_ids = @claims.joins(:item_request).where(item_request_id: (ItemRequest.joins(:item_info).where("item_info.name like ?", "%#{params[:q][:lot_number_cont]}%").ids)).ids
      claim_lot_number_ids = @claims.where("lot_number like ?", "%#{params[:q][:lot_number_cont]}%").ids
      claim_supplier_name_ids = @claims.where(supplier_id: Profile.where("company_name like ?", "%#{params[:q][:lot_number_cont]}%").ids).ids
      ids = item_sku_ids + item_name_ids + claim_lot_number_ids + claim_supplier_name_ids
      @q = @claims.where(id: ids).ransack(params[:q][:lot_number_cont])
    end
    @claims = @q.result.page(params[:page]).per ITEM_PER_PAGE
    render :table
  end

  def info
    @claim = @claims.find_by(id: params[:id])
    if @claim.present?
      @claim.lot_number = params[:claims][:lot_number].to_i
      @claim.claim_content = params[:claims][:claim_content]

      @claim.classify = params[:claims][:classify]

      return redirect_to claim_detail_buyers_claim_path(@claim.id) if @claim.save
    end
    redirect_to buyers_claim_path
  end

  def edit
    @claims = @claims.find(params[:claim_id])
  end

  def claim_detail
    @current_claim = @claims.find_by(id: params[:id])
    @item_info = @current_claim&.item_request&.item_info
    @catalog = @current_claim&.item_request&.catalog
    @claims_images = @current_claim&.claims_image&.map { |image| image.url }
  end

  def auto_display_name
    item_info = ItemInfo.find_by_SKU(params[:claim_item_code])
    render json: item_info
  end

  def list_item_info
    item_info_list = ItemInfo.all
    render json: item_info_list
  end

  def claims_params
    params.permit(Claims::PARAMS_ATTRIBUTES)
  end

  def check_match(string_params, selection_status)
    find_match_string = string_params&.match(Regexp.union(selection_status&.values&.map { |i| Regexp.new(i) }))
    match_string = find_match_string[0] unless find_match_string.nil?
    match_string_index = selection_status&.find_value(match_string)&.value
    match_string_index
  end

  private

  def get_claims
    @claims = current_user.claims
  end

  def initialize_claim
    @claims = Claims.new
  end
end
