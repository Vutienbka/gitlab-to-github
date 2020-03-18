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

  def show_errors(object, field_name)
    if session[:register_errors].present?
      str = "<p class='error-message text-danger'>#{session[:register_errors][field_name.to_s]&.first}</p>"
      return str.html_safe
    end

    return if object&.errors.blank?
    str = "<p class='error-message text-danger'>#{object.errors[field_name.to_s]&.first}</p>"
    str.html_safe
  end
end
