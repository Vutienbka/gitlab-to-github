# frozen_string_literal: true

class Buyers::ItemStandardsController < Buyers::BaseController
  before_action :set_item_request, only: %i[new create edit update]
  before_action :set_item_standard, only: %i[new create edit update]
  before_action :block_input_link, only: %i[new create edit update]

  def new; end

  def create
    if @item_standard.update(item_standard_params)
      flash[:success] = I18n.t('create.success')
      if ItemRequest::STATUSES[@item_request.status.to_sym] < 6
        @item_request.update_attribute(:status, 6)
      end
      redirect_to buyers_item_conditions_path(item_request_id: @item_request.id)
      # Already redirect to next page at my_dropzone.js
    end
  end

  def edit; end

  def update
    if @item_standard.update(item_standard_params)
      flash[:success] = I18n.t('update.success')
      if ItemRequest::STATUSES[@item_request.status.to_sym] < 6
        @item_request.update_attribute(:status, 6)
      end
      @item_request.update_attributes(updater: current_user.id, updated_at: Time.current)
      redirect_to edit_buyers_item_conditions_path(item_request_id: @item_request.id)
      # Already redirect to next page at my_dropzone.js
      # TODO:: redirect to edit next page
    end
  end

  private
  def set_item_standard
    @item_standard = ItemStandard.includes(standard_categories: :file_standard).find_or_create_by(item_request_id: @item_request&.id)
    if @item_standard.standard_categories.blank?
      StandardCategory::TYPES.each do |name|
        @item_standard.standard_categories.build(name: name).build_file_standard
      end
      @item_standard.save
    end
  end

  def item_standard_params
    StandardCategory::TYPES.each_with_index do |_key, index|
      if params.dig(:item_standard, :standard_categories_attributes, index.to_s, :file_standard_attributes, :file_link)
        params[:item_standard][:standard_categories_attributes][index.to_s][:file_standard_attributes][:file_link] = params[:item_standard][:standard_categories_attributes][index.to_s][:file_standard_attributes][:file_link].values
      end
    end

    params.require(:item_standard).permit(ItemStandard::PARAMS_ATTRIBUTES)
  end

  def block_input_link
    if ItemRequest::STATUSES[@item_request.status.to_sym] < 5
      redirect_to root_path
    end
  end
end
