require 'haml'

module LiquidServices
  class ChartLiquid
    def initialize(site_name)
      @site_name = site_name
    end

    def to_h
      { 
        'summary' => summary_html,
        'feedback_sub_categories' => feedback_sub_categories_html,
        'service_popularity' => most_popular_service_html
      }
    end

    private

    def summary_html
      html = File.read("#{template_path}/total_user_feedback.html.haml")
      template = Tilt::HamlTemplate.new { html }
      template.render
    end

    def feedback_sub_categories_html
      html = File.read("#{template_path}/feedback_sub_categories.html.haml")
      template = Tilt::HamlTemplate.new { html }
      template.render(self, 'site_name' => @site_name)
    end

    def most_popular_service_html
      html = File.read("#{template_path}/most_popular_service.html.haml")
      template = Tilt::HamlTemplate.new { html }
      template.render
    end

    def template_path
      'app/views/sites/pdf_templates'
    end
  end
end
