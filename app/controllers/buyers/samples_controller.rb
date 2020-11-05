class Buyers::SamplesController < Buyers::BaseController
  before_action :set_locale, only: %i[create]

  def ledger; end

  def input
    @sample = Sample.new
  end

  def create
    @sample = Sample.new(sample_params)
    @sample.buyer_id = current_user.id
    @sample.updater = current_user.id
    return redirect_to input_buyers_samples_path, flash: { success: t('create.success') } if @sample.save

    flash.now[:alert] = I18n.t('create.failed')
    render :input
  end

  def sample_params
    params.require(:sample).permit(Sample::PARAMS_ATTRIBUTES)
  end

  def set_locale
    I18n.locale = :en
  end
end
