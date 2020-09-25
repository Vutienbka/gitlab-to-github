module ApplicationHelper
  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end

  def destroy_admin_session_path
  end

  def stylesheets(*sass)
    content_for(:head) { stylesheet_link_tag(*sass) }
  end

  def javascripts(*js)
    content_for(:head) { javascript_include_tag(*js) }
  end

  def show_errors_buyer(object, field_name)
    return '' if object.blank? || object[field_name].nil?
    raw "<p class='error-message text-danger'>#{object[field_name].join('')}</p>"
  end

  def show_errors(object, field_name)
    return if object&.errors.blank?
    str = "<p class='error-message text-danger'>#{object.errors[field_name.to_s]&.first}</p>"
    str.html_safe
  end

  def check_params_controller_action(text)
    return true if params[:controller].include?(text) || params[:action].include?(text)
    false
  end

  # Breadcrumb
  def ensure_breadcrumb(title = 'ホーム', url = root_path)
    @breadcrumb ||= [{ title: title, url: url }]
  end

  def breadcrumb_add(title, url = '')
    ensure_breadcrumb << { title: title.html_safe, url: url }
  end

  def render_breadcrumb
    render partial: 'layouts/breadcrumb', locals: { ol: ensure_breadcrumb }
  end

  # Active link sidebar
  def buyer_active_link
    (params[:controller] == 'buyers' &&
      (params[:action] == 'register_item' || params[:action] == 'choose_provider' ||
      params[:action] == 'search_provider' || params[:action] == 'batch_items_selector' ||
      params[:action] == 'invite_unregisted_supplier' || params[:action] == 'complete_introduce')) ||
    (params[:controller] == 'buyers/item_requests' &&
      (params[:action] == 'index' || params[:action] == 'progress'|| params[:action] == 'complete' ||
       params[:action] == 'private_contract_progress')) ||
    (params[:controller] == 'buyers/item_info' &&
      (params[:action] == 'new' || params[:action] == 'edit')) ||
    (params[:controller] == 'buyers/item_drawings' &&
      (params[:action] == 'new' || params[:action] == 'edit')) ||
    (params[:controller] == 'buyers/item_images' &&
      (params[:action] == 'new' || params[:action] == 'edit')) ||
    (params[:controller] == 'buyers/item_qualities' &&
      (params[:action] == 'new' || params[:action] == 'edit')) ||
    (params[:controller] == 'buyers/item_standards' &&
      (params[:action] == 'new' || params[:action] == 'edit')) ||
    (params[:controller] == 'buyers/item_conditions' &&
      (params[:action] == 'new' || params[:action] == 'edit')) ||
    (params[:controller] == 'buyers/inspection_requests' &&
      (params[:action] == 'new' || params[:action] == 'complete_credit_registration'))
  end

  def fetch_item_request_quantity
    if current_user.buyer?
      return @item_request_quantity if defined?(@item_request_quantity)

      quantity = current_user.item_requests.count
      @item_request_quantity = quantity if quantity.positive?
    end
  end

  def fetch_item_request_progress(value)
    ((value.to_f/6)*100).to_s + '%'
  end

  def fetch_item_request_completed_progress(item_request, value)
    item_request.status.value >= value ? 'done': ''
  end

  def disabled_progress(item_request, value)
    item_request.status.value < value ? 'disabled-progress' : ''
  end
end
