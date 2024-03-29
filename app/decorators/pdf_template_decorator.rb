require 'liquid'

class PdfTemplateDecorator < ApplicationDecorator
  delegate_all

  def render(site, start_date, end_date)
    I18n.with_locale(:km) do
      template = Tilt::LiquidTemplate.new { content.html_safe }
      template.render(LiquidServices::BaseLiquid.new(site, start_date, end_date))
    end
  end

  def variables
    hashes.keys.each_with_object([]) do |outer_key, arr|
      hashes[outer_key].keys.each do |inner_key|
        arr << "{{#{outer_key}.#{inner_key}}}"
      end
    end
  end

  private

  def hashes
    return {} unless Site.exists?
    LiquidServices::BaseLiquid.new(Site.first, Date.current, Date.current).to_h
  end

end
