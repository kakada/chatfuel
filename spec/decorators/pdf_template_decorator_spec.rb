require 'rails_helper'

RSpec.describe PdfTemplateDecorator do
  subject { pdf_template.decorate.render(site, Date.today) }

  let(:pdf_template) { create(:pdf_template) }
  let(:site) { build(:site, name_en: 'kamrieng', province_id: "02") }

  context "#render" do
    let(:summary_html) { "Summary HTML" }

    before do
      travel_to Time.local(2021,05,05)
    end

    after do
      travel_back
    end

    it "updates {{site}} template" do
      pdf_template.content = "{{site.name}} {{site.province_name}}"
      expect(subject).to include "បាត់ដំបង"
    end

    it "updates {{date}} template" do
      pdf_template.content = "{{date.current_day}} {{date.current_month}} {{date.current_year}}"
      expect(subject).to eq "05 ឧសភា 2021"
    end

    describe "{{chart.*}} template" do
      let(:template_path) { "app/views/sites/pdf_templates" }

      before do
        allow(File).to receive(:read).with("#{template_path}/total_user_feedback.html.haml").and_return('Summary')
        allow(File).to receive(:read).with("#{template_path}/feedback_sub_categories.html.haml").and_return('Feedback')
        allow(File).to receive(:read).with("#{template_path}/most_popular_service.html.haml").and_return('Popular')
      end

      it "{{chart.summary}}" do
        pdf_template.content = "{{chart.summary}}"
        expect(subject).to include "Summary"
      end

      it "{{chart.feedback_sub_categories}}" do
        pdf_template.content = "{{chart.feedback_sub_categories}}"
        expect(subject).to include "Feedback"
      end

      it "{{chart.service_popularity}}" do
        pdf_template.content = "{{chart.service_popularity}}"
        expect(subject).to include "Popular"
      end
    end
  end
end
