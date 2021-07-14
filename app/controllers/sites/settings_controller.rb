# frozen_string_literal: true

module Sites
  class SettingsController < ApplicationController
    before_action :set_site
    before_action :set_site_setting
    
    def index
      @feedback_setting = @settings.feedbacks_setting.first || @settings.build(type: 'SiteFeedbackSetting')
      @do_report_setting = @settings.do_reports_setting.first || @settings.build(type: 'SiteDoReportSetting')
    end

    def create
      @setting = @settings.build(site_setting_params)
      if @setting.save
        flash[:notice] = I18n.t("sites.succesfully_create_setting")
      else
        flash[:alert] = @setting.errors.full_messages
      end

      redirect_to site_settings_path(@site)
    end

    def update
      @setting = @settings.find(params[:id])

      if @setting.update(site_setting_params)
        flash[:notice] = I18n.t("sites.succesfully_update_setting")
      else
        flash[:alert] = @setting.errors.full_messages
      end

      redirect_to site_settings_path(site_id: @site)
    end

    private

      def set_site_setting
        @settings = @site.site_settings
      end

      def set_site
        @site = Site.find(params[:site_id])
      end

      def site_setting_params
        params.require(:site_setting).permit(:id, :message_template,
          :message_frequency, :digest_message_template,
          :type,
          :enable_notification, telegram_chat_group_ids: []
        )
      end
  end
end
