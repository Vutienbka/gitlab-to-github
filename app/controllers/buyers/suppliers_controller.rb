class Buyers::SuppliersController < Buyers::BaseController
  include StaticData
before_action :supplier, only: %i[show company_hyouka_info company_record_info]
  def index
    return @q = Supplier.ransack if params[:q].blank?
    if params[:supplier_id].present?
    @q = Supplier.ransack({ supplier_id_cont: params[:supplier_id] })
    @search_suppliers = @q.result.where(id: params[:supplier_id])
    else
    @q = Supplier.ransack({ profile_first_name_or_profile_last_name_or_profile_company_name_or_profile_code_cont: params[:q][:profile_company_name_cont] })
    @search_suppliers = @q.result.includes(:profile)
    end
  end

  def show; end

  def company_hyouka_info
  end

  def company_record_info
  end

  def search_with_ajax
    @q = Supplier.where(id: params[:id]).ransack(params[:q])
    @search_suppliers = @q.result.page(params[:page]).per SUPPLIER_ITEM_PER_PAGE
    respond_to do |format| 
      format.js { render json: { html: render_to_string(partial: 'supplier_table', locals: { search_suppliers: @search_suppliers }) } }
    end
  end

  private

  def supplier
    @supplier = Supplier.find_by(id: params[:id])
  end

end
