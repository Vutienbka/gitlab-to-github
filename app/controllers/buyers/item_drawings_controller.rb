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
      @item_request.update_attribute(:status, 3) if ItemRequest::STATUSES[@item_request.status.to_sym] < 3
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
    file_specifications = @item_drawing.file_specifications
    file_specifications += params[:item_drawing][:file_specifications].values if params.dig(:item_drawing, :file_specifications)
    @item_drawing.file_specifications = file_specifications

    file_assembly_specifications = @item_drawing.file_assembly_specifications
    file_assembly_specifications += params[:item_drawing][:file_assembly_specifications].values if params.dig(:item_drawing, :file_assembly_specifications)
    @item_drawing.file_assembly_specifications = file_assembly_specifications

    file_packing_specifications = @item_drawing.file_packing_specifications
    file_packing_specifications += params[:item_drawing][:file_packing_specifications].values if params.dig(:item_drawing, :file_packing_specifications)
    @item_drawing.file_packing_specifications = file_packing_specifications

    @item_drawing.save

    # if @item_drawing.update(item_drawing_params)
    #   @item_request.update_attribute(:status, 3) if ItemRequest::STATUSES[@item_request.status.to_sym] < 3
    #   @item_request.update_attributes(updater: current_user.id, updated_at: Time.current)
    #   respond_to do |format|
    #     format.html { redirect_to item_images_edit_buyers_item_request_path(@item_request), success: I18n.t('update.success') }
    #     format.json { render json: @item_drawing }
    #   end
    # else
    #   flash[:alert] = I18n.t('update.failed')
    #   render :edit
    # end
  end

  def remove_file
    if params[:index_of_file_specifications].present?
      index = params[:index_of_file_specifications].to_i
      remain_files = @item_drawing.file_specifications # copy the array
      deleted_file = remain_files.delete_at(index) # delete the target image
      deleted_file.try(:remove!) # delete image from S3
      @item_drawing.file_specifications = remain_files # re-assign back

      @item_drawing.remove_file_specifications = true if remain_files.empty?
    end

    if params[:index_of_file_assembly_specifications].present?
      index = params[:index_of_file_assembly_specifications].to_i
      remain_files = @item_drawing.file_assembly_specifications # copy the array
      deleted_file = remain_files.delete_at(index) # delete the target image
      deleted_file.try(:remove!) # delete image from S3
      @item_drawing.file_assembly_specifications = remain_files # re-assign back

      @item_drawing.remove_file_assembly_specifications = true if remain_files.empty?
    end

    if params[:index_of_file_packing_specifications].present?
      index = params[:index_of_file_packing_specifications].to_i
      remain_files = @item_drawing.file_packing_specifications # copy the array
      deleted_file = remain_files.delete_at(index) # delete the target image
      deleted_file.try(:remove!) # delete image from S3
      @item_drawing.file_packing_specifications = remain_files # re-assign back

      @item_drawing.remove_file_packing_specifications = true if remain_files.empty?
    end

    @item_drawing.save
  end

  private
  def set_item_drawing
    @item_drawing = ItemDrawing.find_by(item_request_id: @item_request.id) if @item_request.present?
  end

  def item_drawing_params
    params[:item_drawing][:file_specifications] = params[:item_drawing][:file_specifications].values if params.dig(:item_drawing, :file_specifications)
    params[:item_drawing][:file_assembly_specifications] = params[:item_drawing][:file_assembly_specifications].values if params.dig(:item_drawing, :file_assembly_specifications)
    params[:item_drawing][:file_packing_specifications] = params[:item_drawing][:file_packing_specifications].values if params.dig(:item_drawing, :file_packing_specifications)
    params.require(:item_drawing).permit(ItemDrawing::PARAMS_ATTRIBUTES)
  end
end
