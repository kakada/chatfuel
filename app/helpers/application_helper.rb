# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def css_class_name
    "#{controller_path.parameterize}-#{action_name}"
  end

  def render_notice
    content_tag(:div, notice, class: "alert alert-primary", role: "alert") if notice
  end

  def render_alert
    content_tag(:div, alert, class: "alert alert-danger", role: "alert") if alert
  end

  def locale_name(locale)
    { en: "English", km: "ខ្មែរ" }[locale]
  end

  def locale_choices
    %I(en km) - [I18n.locale]
  end

  %w(homes sites dictionaries reports users).each do |ctrl|
    define_method "#{ctrl}?".to_sym do
      controller_name == ctrl
    end
  end

  def css_active_class(controller_name)
    return 'active' if params['controller'].split('/')[0] == controller_name
  end
end
