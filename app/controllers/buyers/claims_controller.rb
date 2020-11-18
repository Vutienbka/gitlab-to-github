# frozen_string_literal: true

class Buyers::ClaimsController < Buyers::BaseController
  include StaticData
  include ChangeLocale
  before_action :set_default_locale, only: %i[new create table show filter]
  before_action :redirect_to_profile
  before_action :item_requests, only: %i[new create]
  before_action :claims, :claim, except: %i[index new]

  def index; end

  def new
    @claim = Claim.new
    @item_info = current_user.item_requests.find_by_id(params[:item_request_id]).item_info
  end

  def create
    @claim = Claim.new(claims_params)
    @claim.supplier_id = @item_request.supplier_id
    @claim.buyer_id = current_user.id
    @claim.reason_status = Claim.reason_status.find_value(t('enumerize.reason_status.unanswered')).value
    @claim.counter_plan_status = Claim.counter_plan_status.find_value(t('enumerize.counter_plan_status.unanswered')).value
    if @claim.save
      respond_to do |format|
        format.html { redirect_to buyers_claim_path(@claim), success: I18n.t('create.success') }
        format.json { render json: @claim.id }
      end
    else
      flash.now[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def show
    @current_claim = @claims.find_by(id: params[:id])
    @item_info = @current_claim&.item_request&.item_info
    @catalog = @current_claim&.item_request&.catalog
    @claims_images = @current_claim&.claims_image&.map { |image| image.url }
  end

  def edit
    @item_info = current_user.claims.find_by(id: params[:id]).item_request.item_info
  end

  def update
    if @claim.present?
      @claim.claims_image = Dropzone::AddFilesService.new('claim', 'claims_image', @claim.claims_image, params).call
      @claim.classify = params[:claim][:classify]
      @claim.claim_content = params[:claim][:claim_content]
      @claim.lot_number = params[:claim][:lot_number]

      if @claim.save
        respond_to do |format|
          format.html { redirect_to buyers_claim_path(@claim), success: I18n.t('create.success') }
          format.json { render json: @claim.id }
        end
      else
        flash.now[:alert] = I18n.t('update.failed')
        render :edit
      end
    end
  end

  def remove_file
    if params[:index_of_claims_image].present?
      remain_files = Dropzone::RemoveFileService.new(params[:index_of_file_specifications], @claim.claims_image).call
      @claim.claims_image = remain_files
      @claim.remove_claims_image = true if remain_files.empty?
    end
    @claim.save
  end

  def destroy
    if @claim.present? && @claim.destroy
      return redirect_to table_buyers_claims_path, flash: { success: I18n.t('destroy.success') }
    end

    flash[:alert] = I18n.t('destroy.failed')
    redirect_to table_buyers_claims_path
  end

  def input; end

  def table
    if params[:q].blank?
      if params[:item_code].blank? || (params[:item_code] == 'blank')
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
      if params[:item_code].blank? || (params[:item_code] == 'blank')
        @q = @claims.ransack(params[:q])
        @claims = @q.result.page(params[:page]).per ITEM_PER_PAGE
      else
        @item_info = ItemInfo.find_by(SKU: params[:item_code])
        @item_request = @item_info&.item_request
        @q = @item_request&.claims.where(buyer_id: current_user.id).ransack(params[:q])
        @claims = @q.result
      end
      string_params = t("enumerize.reason_counter_plans.#{params[:claim][:reason_counter_plans]}")

      if string_params.include? t('enumerize.check_match_param.reason')
        selection_status = @claims.reason_status
        reason_match_string_index = check_match(string_params, selection_status)
      end

      if string_params.include? t('enumerize.check_match_param.counterplan')
        selection_status = @claims.counter_plan_status
        counter_plan_match_string_index = check_match(string_params, selection_status)
      end
      @claim_classify = if params[:claim][:classify].present?
                          t("enumerize.classifies.#{params[:claim][:classify]}")
                        else
                          params[:claim][:classify]
                        end
      @q = @claims&.filter_by_date_range(params[:select_period_from]&.to_date, params[:select_period_to]&.to_date)
                  .filter_by_reason_status(reason_match_string_index)
                  .filter_by_counter_plan_status(counter_plan_match_string_index).ransack(params[:q])
      @claims = @q.result.page(params[:page]).per ITEM_PER_PAGE

      unless @claims.present?
        flash[:alert] = '見つからなかった'
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
      format.js { render json: { html: render_to_string(partial: 'claim_table', locals: { claims: @claims }) } }
    end
  end

  def search_by_submit
    if params[:item_code].blank? || (params[:item_code] == 'blank')
      @claims = @claims
    else
      @item_info = ItemInfo.find_by(SKU: params[:item_code])
      @item_request = @item_info&.item_request
      @claims = @item_request&.claims.where(buyer_id: current_user.id)
    end
    if params[:q][:lot_number_cont].blank?
      @q = @claims.ransack(params[:q][:lot_number_cont])
    else
      item_sku_ids = @claims.joins(:item_request).where(item_request_id: ItemRequest.joins(:item_info).where('item_info.SKU like ?', "%#{params[:q][:lot_number_cont]}%").ids).ids
      item_name_ids = @claims.joins(:item_request).where(item_request_id: ItemRequest.joins(:item_info).where('item_info.name like ?', "%#{params[:q][:lot_number_cont]}%").ids).ids
      claim_lot_number_ids = @claims.where('lot_number like ?', "%#{params[:q][:lot_number_cont]}%").ids
      claim_supplier_name_ids = @claims.where(supplier_id: Profile.where('company_name like ?', "%#{params[:q][:lot_number_cont]}%").ids).ids
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
      @claim.claims_image = params[:claims][:claims_image]
      @claim.classify = params[:claims][:classify]

      return render :success if @claim.save
    end
    redirect_to buyers_claim_path
  end

  def auto_display_name
    item_info = ItemInfo.find_by_SKU(params[:claim_item_code])
    render json: item_info
  end

  def list_item_info
    item_info_list = ItemInfo.where(item_request_id: current_user.item_requests.ids)
    render json: item_info_list
  end

  def check_match(string_params, selection_status)
    find_match_string = string_params&.match(Regexp.union(selection_status&.values&.map { |i| Regexp.new(i) }))
    match_string = find_match_string[0] unless find_match_string.nil?
    match_string_index = selection_status&.find_value(match_string)&.value
    match_string_index
  end

  private

  def claims_params
    params[:claim][:claims_image] = params[:claim][:claims_image].values if params.dig(:claim, :claims_image)
    params.require(:claim).permit(Claim::PARAMS_ATTRIBUTES)
  end

  def claims
    @claims = current_user.claims
  end

  def claim
    @claim = @claims.find_by(id: params[:id]) if @claims.present?
  end

  def item_requests
    @item_requests = current_user.item_requests
    @item_request = @item_requests.find_by(id: params[:item_request_id]) if @item_requests.present?
    return redirect_to buyers_claims_path, flash: { alert: 'Do not have permission' } unless @item_request.present?
  end
end
