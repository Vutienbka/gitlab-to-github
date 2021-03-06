class Buyers::CatalogItemsController < Buyers::BaseController
  include StaticData
  before_action :set_catalog

  def index
    if params[:q].blank?
      @q = current_user&.item_requests.ransack(params[:q])
      @item_requests = @q.result.page(params[:page]).per 10
    else
      item_sku_id = current_user&.item_requests.joins(:item_info).where('item_info.SKU like ?', "%#{params[:q][:status_cont]}%").ids
      item_name_id = current_user&.item_requests.joins(:item_info).where('item_info.name like ?', "%#{params[:q][:status_cont]}%").ids
      catalog_id = current_user&.item_requests.includes(:catalog).where(catalog_id: Catalog.where("name like ? ", "%#{params[:q][:status_cont]}%").ids).ids
      supplier_id = current_user&.item_requests.where(supplier_id: Profile.where('first_name like ? ', "%#{params[:q][:status_cont]}%").ids).ids
      ids = item_sku_id + item_name_id + catalog_id + supplier_id
      @item_requests = current_user&.item_requests.where(id: ids).includes([:item_info])

      @q = @item_requests.ransack.result.page(params[:page]).per 10
      render :search unless @item_requests.nil?
    end
    if check_exist_of_items(@catalog).present?
      redirect_to buyers_catalog_catalog_items_path(@catalog.id)
    end
    @catalog_items = @catalog.item_requests.where(status: 7).page(params[:page]).per ITEM_PER_PAGE
  end

  def show
    @item_request = Catalog.find_by(id: params[:catalog_id]).item_requests.find_by(id: params[:id])
    @supplier = Supplier.find_by(id: @item_request.supplier_id)
    @item_images = @item_request.item_image.file_images.map { |image| image.url }
    @cost = @item_request&.item_info&.cost
    @exchange_rate = ExchangeRateService.new('JPY','USD')
    @exchange_rate_to_usd = @exchange_rate.call
  end

  def download_drawing
    @item_request = Catalog.find_by(id: params[:catalog_id]).item_requests.find_by(id: params[:catalog_item_id])
    @file_name_version = Time.now.to_i.to_s
    if @item_request.present?
      case params[:check_input_value]
      when 'file_specifications'
        @file_paths = @item_request&.item_drawing.file_specifications&.map { |drawing| drawing.url }
      when 'file_assembly_specifications'
        @file_paths = @item_request&.item_drawing.file_assembly_specifications&.map { |drawing| drawing.url }
      else
        @file_paths = @item_request&.item_drawing.file_packing_specifications&.map { |drawing| drawing.url }
      end
      download_zip_file(params[:check_input_value])
    end
  end

  def check_exist_of_items(catalog)
    @current_user.item_requests.where(catalog_id: catalog.id)
  end

  def download_zip_file(field_name)
    @item_drawings = ItemServices::DownloadService.new(@item_request, field_name, @file_name_version, @file_paths).call
    if @item_drawings.success?
      send_file @item_drawings.path_file_zip, type: 'application/zip'
    else
      flash[:alert] = 'ファイルが見つからなかった'
      return redirect_to buyers_catalog_catalog_item_path(@catalog, @item_request)
    end
  end

  private

  def set_catalog
    @catalog = Catalog.find_by(id: params[:catalog_id])
    if @catalog.level_type.eql? 'grandchild_catalog'
      @grandchild_catalog = @catalog
      @sub_catalog = Catalog.find_by(id: @grandchild_catalog.parent_catalog_id)
      @parent_catalog = Catalog.find_by(id: @sub_catalog.parent_catalog_id)
    elsif @catalog.level_type.eql? 'sub_catalog'
      @sub_catalog = @catalog
      @parent_catalog = Catalog.find_by(id: @sub_catalog.parent_catalog_id)
    else
      @parent_catalog = @catalog
    end
  end
end
