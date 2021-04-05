# frozen_string_literal: true

module Sites
  class ApiKeysController < PrivateAccessController
    before_action :set_site

    def show
    end

    def update
      if @site.update_attributes(site_params)
        flash[:notice] = I18n.t("sites.update_api_success")
      else
        flash[:alert] = @site.errors.full_messages
      end

      redirect_to site_api_key_path(@site)
    end

    private
      def set_site
        @site = Site.find(params[:site_id])
      end

      def site_params
        params.require(:site).permit(:id, :token, :whitelist)
      end
  end
end
