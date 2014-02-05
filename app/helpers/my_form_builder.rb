class MyFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    errors = object.errors[method.to_sym]
    if errors.any?
      "#{super} <div class=\"has-error\">#{errors.first}</div>".html_safe
    else
      super
    end
  end
end