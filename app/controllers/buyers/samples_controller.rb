class Buyers::SamplesController < Buyers::BaseController
  before_action :set_default_locale
  before_action :set_locale, only: %i[create new input]
  before_action :set_sample, only: %i[edit update destroy]
  before_action :samples, only: %i[filter suppliers ledger]

  def ledger
    filter_conditions(samples)
  end

  def input
    @sample = Sample.new
  end

  def create
    @sample = Sample.new(sample_params)
    @sample.buyer_id = current_user.id
    @sample.updater = current_user.id

    return redirect_to input_buyers_samples_path, flash: { success: t("create.success") } if @sample.save

    flash.now[:alert] = I18n.t("create.failed")
    render :input
  end

  def suppliers
    @samples = @samples.where(sample_type: params[:sample_type]) if params[:sample_type].present?
    @conditions = filter_conditions(@samples)
    @suppliers = @conditions.first.includes(:profile).pluck(:company_name)
    @catalogs = @conditions.last.pluck(:name)
    respond_to do |format|
      format.json { render :json => { :suppliers => @suppliers, :catalogs => @catalogs } }
    end
  end

  def filter
    @samples = @samples&.filter_by_sample_type(params.dig(:sample, :sample_type))
      .filter_by_supplier_name(params.dig(:sample, :supplier))
      .filter_by_catalog_name(params.dig(:sample, :category))

    filter_conditions(@samples)
    render :ledger
  end

  def edit; end

  def update
    @sample.update(sample_params)
    flash[:success] = I18n.t('update.success')
    redirect_to ledger_buyers_samples_path
  end

  def destroy
    if @sample.present? && @sample.destroy
      flash[:success] = I18n.t('destroy.success')
      redirect_to ledger_buyers_samples_path and return
    end
    flash[:alert] = I18n.t('destroy.failed')
    redirect_to ledger_buyers_samples_path and return
  end

  private

  def sample_params
    params.require(:sample).permit(Sample::PARAMS_ATTRIBUTES)
  end

  def set_sample
    @sample = current_user.samples.find_by_id(params[:id])
  end

  def set_locale
    I18n.locale = :en
  end

  def set_default_locale
    I18n.locale = :ja
  end

  def samples
    @samples = current_user.samples
  end

  def filter_conditions(samples)
    item_requests = ItemRequest.where(id: samples.pluck(:item_request_id))
    supplier_ids = item_requests.pluck(:supplier_id)
    @suppliers = Supplier.where(id: supplier_ids)
    @catalogs = Catalog.where(id: item_requests.pluck(:catalog_id))
    conditions ||= []
    conditions << @suppliers
    conditions << @catalogs
    conditions
  end
end
