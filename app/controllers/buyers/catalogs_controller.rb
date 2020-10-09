# frozen_string_literal: true

class Buyers::CatalogsController < Buyers::BaseController
  before_action :get_parent_catalogs

  def index; end

  def create
    @catalog = Catalog.new(catalog_params)
    return redirect_to buyers_catalogs_path, flash: { success: I18n.t('create.success') } if @catalog.save

    flash[:alert] = I18n.t('create.failed')
    redirect_to buyers_catalogs_path
  end

  def update
    @catalog = @catalogs.find_by(id: params[:id])
    return redirect_to buyers_catalogs_path, flash: { success: I18n.t('update.success') } if @catalog.update(name: params[:catalog][:name])
    flash[:alert] = I18n.t('update.failed')
    redirect_to buyers_catalogs_path
  end

  def destroy
    @catalog = @catalogs.find_by(id: params[:id])
    return redirect_to buyers_catalogs_path, flash: { success: I18n.t('destroy.success') } if @catalog.destroy
    flash[:alert] = I18n.t('destroy.failed')
    redirect_to buyers_catalogs_path
  end

  def get_selected_catalog
    @catalog = @catalogs.find_by(id: params[:catalog_id])
    respond_to do |format|
      format.json { render json: @catalog }
    end
  end
  def get_catalog_after_click
    @catalog = Catalog.find_by(id: params[:id])
    respond_to do |format|
      format.json { render json: @catalog }
    end
  end
  private

  def get_parent_catalogs
    @catalogs = Catalog.where(level_type: 'parent')
  end

  def catalog_params
    params.require(:catalog).permit(:name, :parent_catalog_id, :level_type)
  end
end
