class Buyers::SamplesController < Buyers::BaseController
  include StaticData
  include ChangeLocale
  before_action :set_default_locale
  before_action :set_locale, only: %i[create new input edit update]
  before_action :samples, only: %i[filter suppliers ledger search_by_submit search_with_ajax]
  before_action :set_sample, only: %i[edit update destroy info]
  before_action :item_requests, only: %i[search_by_submit filter_conditions create update]

  def ledger
    filter_conditions(@samples)
    @q = @samples.ransack(params[:q])
    @samples = @q.result.page(params[:page]).per SAMPLE_ITEM_PER_PAGE
  end

  def input
    @sample = Sample.new
    @patterns = @sample.patterns.build
  end

  def create
    @sample = Sample.new(sample_params)
    @sample.buyer_id = current_user.id
    @sample.updater = current_user.id

    if params[:sample][:code].present?
      item_request_id = @item_requests&.joins(:item_info)
                                      .where('item_info.SKU = ?', (params[:sample][:code]).to_s)
                                      .first&.item_info&.item_request_id
      if item_request_id.present?
        @sample.item_request_id = item_request_id
        return redirect_to input_buyers_samples_path, flash: { success: t('create.success') } if @sample.save
      end
    else
      return redirect_to input_buyers_samples_path, flash: { success: t('create.success') } if @sample.save
    end
    flash.now[:alert] = I18n.t('create.failed')
    render :input
  end

  def edit; end

  def suppliers
    @samples = @samples.where(sample_type: params[:sample_type]) if params[:sample_type].present?
    @conditions = filter_conditions(@samples)
    @suppliers = @conditions.first.includes(:profile).pluck(:company_name)
    @catalogs = @conditions.last.pluck(:name)

    respond_to do |format|
      format.json { render json: { suppliers: @suppliers, catalogs: @catalogs } }
    end
  end

  def filter
    if params[:q].blank?
      @samples = @samples&.filter_by_sample_type(params.dig(:sample, :sample_type))
                         .filter_by_supplier_name(params.dig(:sample, :supplier))
                         .filter_by_catalog_name(params.dig(:sample, :category))
    end
    @q = @samples.ransack(params[:q])
    @samples = @q.result.page(params[:page]).per SAMPLE_ITEM_PER_PAGE
    filter_conditions(@samples)

    render :ledger
  end

  def search_by_submit
    if params[:q].blank?
      @q = @samples.ransack(params[:q])
    else
      supplier_name_or_code_ids = @samples.search_by_supplier_name_or_code(@item_requests, params[:q][:code_cont]).ids
      sample_title_or_code_ids = @samples.search_by_sample_title_or_code(@samples, params[:q][:code_cont]).ids
      catalog_name_ids = @samples.search_by_catalog_name(@item_requests, params[:q][:code_cont])
      sample_ids = supplier_name_or_code_ids + sample_title_or_code_ids + catalog_name_ids
      @q = @samples.where(id: sample_ids).ransack(params[:q][:code_cont])
    end

    @samples = @q.result.page(params[:page]).per SAMPLE_ITEM_PER_PAGE
    filter_conditions(@samples)
  end

  def update
    if params[:sample][:code].present?
      item_request_id = @item_requests&.joins(:item_info)
                                      .where('item_info.SKU = ?', (params[:sample][:code]).to_s)
                                      .first&.item_info&.item_request_id
      if item_request_id.present?
        @sample.item_request_id = item_request_id
        if @sample.update(sample_params)
          return redirect_to ledger_buyers_samples_path, flash: { success: t('create.success') }
        end
      end
    else
      if @sample.update(sample_params)
        return redirect_to ledger_buyers_samples_path, flash: { success: t('create.success') }
      end
    end
    flash.now[:alert] = I18n.t('create.failed')
    render :edit
  end

  def destroy
    if @sample.present? && @sample.destroy
      flash[:success] = I18n.t('destroy.success')
      redirect_to ledger_buyers_samples_path and return
    end
    flash[:alert] = I18n.t('destroy.failed')
    redirect_to ledger_buyers_samples_path and return
    render :ledger
  end

  def search_with_ajax
    @q = @samples.where(id: params[:id]).ransack(params[:q])
    @samples = @q.result.page(params[:page]).per SAMPLE_ITEM_PER_PAGE
    respond_to do |format|
      format.js { render json: { html: render_to_string(partial: 'sample_table', locals: { samples: @samples }) } }
    end
  end

  def info
    @arr_quality = ''
    @quality = Sample&.find_by_id(params[:id])&.item_request&.item_quality
    @profile = current_user&.profile
    @registrant = Profile.find_by_buyer_id(@sample.buyer_id)
    if @quality&.info2.present?
      @info2 = @quality.info2.slice(0..1)
      @arr_quality += @info2
    end
    if @quality&.info3.present?
      @info3 = @quality.info3.slice(0..1)
      @arr_quality += (',' + @info3)
    end
    if @quality&.info4.present?
      @info4 = @quality.info4.slice(0..1)
      @arr_quality += (',' + @info4)
    end
  end

  private

  def sample_params
    params.require(:sample).permit(Sample::PARAMS_ATTRIBUTES)
  end

  def samples
    @samples = current_user.samples
  end

  def set_sample
    samples
    @sample = @samples&.find_by(id: params[:id]) if @samples.present?
  end

  def filter_conditions(samples)
    item_requests = current_user.item_requests&.where(id: samples.pluck(:item_request_id))
    supplier_ids = item_requests&.pluck(:supplier_id)
    @suppliers = Supplier.where(id: supplier_ids)
    @catalogs = Catalog.where(id: item_requests&.pluck(:catalog_id))
    conditions ||= []
    conditions << @suppliers
    conditions << @catalogs
    conditions
  end

  def item_requests
    @item_requests = current_user.item_requests
  end
end
