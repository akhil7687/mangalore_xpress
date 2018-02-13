module ApplicationHelper
   def bootstrap_class_for flash_type
    case flash_type
    when :success,'success'
      "alert-success"
    when :error,'error'
      "alert-danger"
    when :warning,'warning'
      "alert-warning"
    when :alert,'alert'
      "alert-warning"
    when :notice,'notice'
      "alert-info"
    when :payment_error,'payment_error'
      "alert-payment"
    when :sucess_high,'sucess_high'
      "alert-high-success"
    else
      flash_type.to_s
    end
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def is_active(controller, action,check_ac=false)
    if check_ac
      params[:action] == action && params[:controller] == controller ? "active" : nil
    else
      params[:controller] == controller ? "active" : nil
    end
  end



  def active_page(active_page)
    @active == active_page ? "active" : ""
  end

  def honeypot
    content_tag('div', :style => 'position: absolute; left: -2000px;') do
      text_field_tag('its_so_sweet[email]','john@kdk.in',:tabindex=>900) +
      text_field_tag('its_so_sweet[name]','',:tabindex=>901) +
      check_box_tag('its_so_sweet[agree]',1,false,:tabindex=>902)
    end
  end
end
