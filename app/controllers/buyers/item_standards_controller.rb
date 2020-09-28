# frozen_string_literal: true

class Buyers::ItemStandardsController < Buyers::BaseController
  before_action :set_item_request
  before_action :set_item_standard, except: %i[create]

  def new
    return redirect_to item_standards_edit_buyers_item_request_path(@item_request) if @item_standard.present?

    @item_standard = @item_request.build_item_standard
  end

  def create
    @item_standard = @item_request.build_item_standard(item_standard_params)

    if @item_standard.save
      @item_request.update_attribute(:status, 5) if ItemRequest::STATUSES[@item_request.status.to_sym] < 5
      respond_to do |format|
        format.html { redirect_to item_conditions_new_buyers_item_request_path(@item_request), success: I18n.t('create.success') }
        format.json { render json: @item_standard }
      end
    else
      flash[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def edit
    redirect_to item_standards_new_buyers_item_request_path(@item_request) if @item_standard.blank?
  end

  def update
    @item_standard.file_inspection_criteria = add_files('file_inspection_criteria', @item_standard.file_inspection_criteria, params)
    @item_standard.file_test_criteria = add_files('file_test_criteria', @item_standard.file_test_criteria, params)

    if @item_standard.save
      @item_request.update_attribute(:status, 5) if ItemRequest::STATUSES[@item_request.status.to_sym] < 5
      @item_request.update_attributes(updater: current_user.id, updated_at: Time.current)
      respond_to do |format|
        format.html { redirect_to item_conditions_edit_buyers_item_request_path(@item_request), success: I18n.t('update.success') }
        format.json { render json: @item_standard }
      end
    else
      flash[:alert] = I18n.t('update.failed')
      render :edit
    end
  end

  def remove_file
    if params[:index_of_file_inspection_criteria].present?
      inspection_criteria_remain_files = remove(params[:index_of_file_inspection_criteria], @item_standard.file_inspection_criteria)
      @item_standard.file_inspection_criteria = inspection_criteria_remain_files
      @item_standard.remove_file_inspection_criteria = true if inspection_criteria_remain_files.empty?
    end

    if params[:index_of_file_test_criteria].present?
      test_criteria_remain_files = remove(params[:index_of_file_test_criteria], @item_standard.file_test_criteria)
      @item_standard.file_test_criteria = test_criteria_remain_files
      @item_standard.remove_file_test_criteria = true if test_criteria_remain_files.empty?
    end

    @item_request.update_attributes(updater: current_user.id, updated_at: Time.current) if @item_standard.save
  end

  private
  def set_item_standard
    @item_standard = @item_request.item_standard if @item_request.present?
  end

  def item_standard_params
    params[:item_standard][:file_inspection_criteria] = params[:item_standard][:file_inspection_criteria].values if params.dig(:item_standard, :file_inspection_criteria)
    params[:item_standard][:file_test_criteria] = params[:item_standard][:file_test_criteria].values if params.dig(:item_standard, :file_test_criteria)
    params.require(:item_standard).permit(ItemStandard::PARAMS_ATTRIBUTES)
  end

  def add_files(string, remain_files, params)
    added_files = remain_files
    added_files += params[:item_standard][string.to_sym].values if params.dig(:item_standard, string.to_sym)
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
