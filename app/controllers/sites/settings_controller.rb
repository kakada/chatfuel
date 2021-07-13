# frozen_string_literal: true

module Sites
  class SettingsController < ApplicationController
    before_action :set_site

    def show
      @setting = @site.site_settings.build
      @settings = @site.site_settings
    end

    def create
      @setting = @site.build_site_setting(site_setting_params)
      if @setting.save
        flash[:notice] = I18n.t("sites.succesfully_create_setting")
      else
        flash[:alert] = @setting.errors.full_messages
      end

      redirect_to site_setting_path(@site)
    end

    def update
      @setting = @site.site_setting

      if @setting.update(site_setting_params)
        flash[:notice] = I18n.t("sites.succesfully_update_setting")
      else
        flash[:alert] = @setting.errors.full_messages
      end

      redirect_to site_setting_path(@site)
    end

    private
      def set_site
        @site = Site.find(params[:site_id])
      end

      def site_setting_params
        params.require(:site_setting).permit(:id, :message_template,
          :message_frequency, :digest_message_template,
          :enable_notification, telegram_chat_group_ids: []
        )
      end
  end
end
