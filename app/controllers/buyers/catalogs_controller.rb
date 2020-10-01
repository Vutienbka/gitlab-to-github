# frozen_string_literal: true

class Buyers::CatalogsController < Buyers::BaseController
  before_action :get_parent_catalogs, only: %i[index sub_catalog_index create_sub_catalog]
  before_action :get_sub_catalogs, only: %i[grandchild_catalog_index create_grandchild_catalog]

  def index; end

  def sub_catalog_index
    @catalog = @catalogs.find_by(id: params[:id])
    @sub_catalogs = Catalog.where(parent_catalog_id: params[:id])
  end

  def grandchild_catalog_index
    @sub_catalog = @sub_catalogs.find_by(id: params[:id])
    @grandchild_catalogs = Catalog.where(parent_catalog_id: params[:id])
  end

  def create
    @catalog = Catalog.new(catalog_params)
    return redirect_to buyers_catalogs_path, success: I18n.t("create.success") if @catalog.save
    flash[:alert] = I18n.t('create.failed')
    redirect_to buyers_catalogs_path
  end

  def create_sub_catalog
    @catalog = @catalogs.find_by(id: params[:id])
    @sub_catalog = Catalog.new(catalog_params)
    return redirect_to get_sub_catalog_index_buyers_catalog_path(@catalog.id), success: I18n.t("create.success") if @sub_catalog.save
    flash[:alert] = I18n.t('create.failed')
    redirect_to get_sub_catalog_index_buyers_catalog_path(@catalog.id)
  end

  def create_grandchild_catalog
    @sub_catalog = @sub_catalogs.find_by(id: params[:id])
    @granchild_catalog = Catalog.new(catalog_params)
    return redirect_to buyers_get_grandchild_catalog_index_path(@sub_catalog.id), success: I18n.t("create.success") if @granchild_catalog.save
    flash.now[:error] = I18n.t("create.failed")
    redirect_to buyers_get_grandchild_catalog_index_path(@sub_catalog.id)
  end
  
  def update; end

  private

  def get_parent_catalogs
    @catalogs = Catalog.where(level_type: "parent")
  end

  def get_sub_catalogs
    @sub_catalogs = Catalog.where(level_type: "sub_catalog")
    @catalog = Catalog.find_by(id: @sub_catalogs.first.parent_catalog_id)
  end

  def catalog_params
    params.require(:catalog).permit(:name).merge!(parent_catalog_id: params[:parent_catalog_id], level_type: params[:level_type])
  end
end
