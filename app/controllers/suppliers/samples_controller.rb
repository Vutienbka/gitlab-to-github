class Suppliers::SamplesController < Suppliers::BaseController
  before_action :sample, only: %i[table info]
  before_action :samples, only: %i[table filter_conditions ledger]

  def index; end

  def table; end

  def delivery
    @sample_delivery = SampleDelivery.new
  end

  def ledger; end

  def delivery_submit
    @sample_delivery = SampleDelivery.new(sample_params)
    if @sample_delivery.save
      @sample = Sample.find_by_id(@sample_delivery.samples_id)
      @sample.status = Sample::SAMPLE_STATUS
      @sample.save
      flash.now[:success] = I18n.t('create.success')
      redirect_to table_suppliers_samples_path
    else
      flash.now[:alert] = I18n.t('create.failed')
      render :delivery
    end
  end

  def info
    @registrant = Profile.find_by_buyer_id(@sample.buyer_id)
  end

  private

  def sample_params
    params.require(:sample_delivery).permit(SampleDelivery::PARAMS_ATTRIBUTES)
  end

  def sample
    @sample = Sample.find_by_id(params[:id])
  end

  def samples
    item_request = current_user.item_request
    @list_table = []
    item_request.each do |f|
      @list_table += f.samples
    end
    @list_table
  end
end