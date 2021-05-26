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

  def get_css_active_class(name)
    return 'active' if params['platform'] == name
  end

  %w(homes sites dictionaries reports users).each do |ctrl|
    define_method "#{ctrl}?".to_sym do
      controller_name == ctrl
    end
  end

  def css_active_class(controller_name)
    return 'active' if params['controller'].split('/')[0] == controller_name
  end

  def display_datetime(datetime, format = :long)
    return '' if datetime.blank?

    I18n.l(datetime, format: format)
  end

  def role_html(role_name)
    role = get_role(role_name)

    dom = "<span class='badge badge-pill badge-primary p-2' style='background-color: #{role[:color]}'>"
    dom += "<i class='#{role[:icon]}'></i> #{role_name.humanize}"
    dom += "</span>"
    dom
  end

  def role_icon(role_name)
    role = get_role(role_name)

    "<i class='#{role[:icon]}' style='color: #{role[:color]}'></i>"
  end

  def template_image_dimension(template)
    dimension = ActiveStorage::Analyzer::ImageAnalyzer.new(template.image).metadata
    w = dimension[:width] >= dimension[:height] ? (280 * dimension[:width] / dimension[:height]) : 280
    h = dimension[:width] >= dimension[:height] ? 280 : (280 * dimension[:height] / dimension[:width])

    { width: w, height: h }
  end

  def get_role(role_name)
    roles = {
      site_ombudsman: { icon: 'fas fa-user', color: '#d23528' },
      site_admin: { icon: 'fas fa-user-friends', color: '#b620e0' },
      system_admin: { icon: 'fas fa-users-cog', color: '#4e73df' }
    }

    roles[role_name.to_sym]
  end

  def embed
    controller_name == 'reports'
  end

end
