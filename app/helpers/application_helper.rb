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
end
