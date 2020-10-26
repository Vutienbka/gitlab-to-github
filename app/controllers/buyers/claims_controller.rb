# frozen_string_literal: true

class Buyers::ClaimsController < Buyers::BaseController
  before_action :redirect_to_profile, except: %i[list_claim]

  def index
    @claims = Claims.new()
  end

  def new
  end

  def create
    @claim = Claims.new(claims_params)
    begin
      ActiveRecord::Base.transaction do
        @claim.save
        item_request = ItemInfo.find_by(SKU: params[:claim_item_code]).item_request
        @claim.update_attributes(item_request_id: item_request.id, supplier_id: item_request.supplier_id)
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
      if params[:item_code].blank? || (params[:item_code]&.eql? "blank")
        @q = Claims.ransack(params[:q])
        @claims = @q.result.page(params[:page]).per 10
        return
      end
      @item_info = ItemInfo.find_by(SKU: params[:item_code])
      @item_request = @item_info&.item_request
      @q = @item_request&.claims.ransack(params[:q])
      @claims = @q.result.page(params[:page]).per 10
    else
    end
  end

  def filter
    if params[:q].blank?
      if params[:item_code].blank? || (params[:item_code].eql? "blank")
        @q = Claims.ransack(params[:q])
        @claims = @q.result.page(params[:page]).per 10
      else
        @item_info = ItemInfo.find_by(SKU: params[:item_code])
        @item_request = @item_info&.item_request
        @q = @item_request&.claims.ransack(params[:q])
        @claims = @q.result
      end
      string_params = params[:claim][:reason_counter_plans]

      if string_params.include? "原因"
        selection_status = Claims.reason_status
        reason_match_string_index = check_match(string_params, selection_status)
      end

      if string_params.include? "対策"
        selection_status = Claims.counter_plan_status
        counter_plan_match_string_index = check_match(string_params, selection_status)
      end
      @claim_classify = Claims.classifies.find_value(params[:claim][:classify])
      @claim_classify_param = params[:claim][:classify];
      @q = @claims&.filter_by_date_range(params[:select_period_from]&.to_date, params[:select_period_to]&.to_date)
        .filter_by_reason_status(reason_match_string_index)
        .filter_by_counter_plan_status(counter_plan_match_string_index).ransack(params[:q])
      @claims = @q.result.page(params[:page]).per 10

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
    @q = Claims.where(id: params[:id]).ransack(params[:q])
    @claims = @q.result.page(params[:page]).per 10
    respond_to do |format|
      format.js { render json: { html: render_to_string(partial: "claim_table", locals: { claims: @claims }) } }
    end
  end

  def search_by_submit
    if params[:item_code].blank? || (params[:item_code].eql? "blank")
      @claims = Claims.all
    else
      @item_info = ItemInfo.find_by(SKU: params[:item_code])
      @item_request = @item_info&.item_request
      @claims = @item_request&.claims
    end
    if params[:q][:lot_number_cont].blank?
      @q = @claims.ransack(params[:q][:lot_number_cont])
    else
      item_sku_ids = Claims.joins(:item_request).where(item_request_id: (ItemRequest.joins(:item_info).where("item_info.SKU like ?", "%#{params[:q][:lot_number_cont]}%").ids)).ids
      item_name_ids = Claims.joins(:item_request).where(item_request_id: (ItemRequest.joins(:item_info).where("item_info.name like ?", "%#{params[:q][:lot_number_cont]}%").ids)).ids
      claim_lot_number_ids = Claims.where("lot_number like ?", "%#{params[:q][:lot_number_cont]}%").ids
      claim_supplier_name_ids = Claims.where(supplier_id: Profile.where("company_name like ?", "%#{params[:q][:lot_number_cont]}%").ids).ids
      ids = item_sku_ids + item_name_ids + claim_lot_number_ids + claim_supplier_name_ids
      @q = @claims.where(id: ids).ransack(params[:q][:lot_number_cont])
    end
    @claims = @q.result.page(params[:page]).per 10
    render :table
  end

  def info
    @claim = Claims.find_by(id: params[:id])
    if @claim.present?
      @claim.lot_number = params[:claims][:lot_number].to_i
      @claim.claim_content = params[:claims][:claim_content]
      @claim.claims_image = params[:claims][:claims_image]
      @claim.classify = params[:claims][:classify]
      @claim.save
    end
  end

  def edit
    @claims = Claims.find(params[:claim_id])
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
end
