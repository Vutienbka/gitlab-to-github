# frozen_string_literal: true

class Buyers::ItemDrawingsController < Buyers::BaseController
  before_action :set_item_request
  before_action :set_item_drawing, except: %i[create]

  def new
    return redirect_to item_drawings_edit_buyers_item_request_path(@item_request) if @item_drawing.present?
    @item_drawing = @item_request.build_item_drawing
  end

  def create
    @item_drawing = @item_request.build_item_drawing(item_drawing_params)
    if @item_drawing.save
      @item_request.update_attribute(:status, get_count)
      respond_to do |format|
        format.html { redirect_to item_images_new_buyers_item_request_path(@item_request), success: I18n.t('create.success') }
        format.json { render json: @item_drawing }
      end
    else
      flash[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def edit
    redirect_to item_drawings_new_buyers_item_request_path(@item_request) if @item_drawing.blank?
  end

  def update
    @item_drawing.file_specifications = add_files('file_specifications', @item_drawing.file_specifications, params)
    @item_drawing.file_assembly_specifications = add_files('file_assembly_specifications', @item_drawing.file_assembly_specifications, params)
    @item_drawing.file_packing_specifications = add_files('file_packing_specifications', @item_drawing.file_packing_specifications, params)

    if @item_drawing.save
      @item_request.update_attribute(:status, get_count)
      @item_request.update_attributes(updater: current_user.id, updated_at: Time.current)
      respond_to do |format|
        format.html { redirect_to item_images_edit_buyers_item_request_path(@item_request), success: I18n.t('update.success') }
        format.json { render json: @item_drawing }
      end
    else
      flash[:alert] = I18n.t('update.failed')
      render :edit
    end
  end

  def remove_file
    if params[:index_of_file_specifications].present?
      specifications_remain_files = remove(params[:index_of_file_specifications], @item_drawing.file_specifications)
      @item_drawing.file_specifications = specifications_remain_files
      @item_drawing.remove_file_specifications = true if specifications_remain_files.empty?
    end

    if params[:index_of_file_assembly_specifications].present?
      assembly_specifications_remain_files = remove(params[:index_of_file_assembly_specifications], @item_drawing.file_assembly_specifications)
      @item_drawing.file_assembly_specifications = assembly_specifications_remain_files
      @item_drawing.remove_file_assembly_specifications = true if assembly_specifications_remain_files.empty?
    end

    if params[:index_of_file_packing_specifications].present?
      packing_specifications_remain_files = remove(params[:index_of_file_packing_specifications], @item_drawing.file_packing_specifications)
      @item_drawing.file_packing_specifications = packing_specifications_remain_files
      @item_drawing.remove_file_packing_specifications = true if packing_specifications_remain_files.empty?
    end

    @item_request.update_attributes(updater: current_user.id, updated_at: Time.current) if @item_drawing.save
  end

  private
  def set_item_drawing
    @item_drawing = @item_request.item_drawing if @item_request.present?
  end

  def item_drawing_params
    params[:item_drawing][:file_specifications] = params[:item_drawing][:file_specifications].values if params.dig(:item_drawing, :file_specifications)
    params[:item_drawing][:file_assembly_specifications] = params[:item_drawing][:file_assembly_specifications].values if params.dig(:item_drawing, :file_assembly_specifications)
    params[:item_drawing][:file_packing_specifications] = params[:item_drawing][:file_packing_specifications].values if params.dig(:item_drawing, :file_packing_specifications)
    params.require(:item_drawing).permit(ItemDrawing::PARAMS_ATTRIBUTES)
  end

  def add_files(string, remain_files, params)
    added_files = remain_files
    added_files += params[:item_drawing][string.to_sym].values if params.dig(:item_drawing, string.to_sym)
    remain_files = added_files
  end

  def remove(index_of, remain_files)
    index = index_of.to_i
    current_files = remain_files # copy the array
    deleted_file = current_files.delete_at(index) # delete the target image
    deleted_file.try(:remove!) # delete image from S3
    remain_files = current_files # re-assign back
  end
end
