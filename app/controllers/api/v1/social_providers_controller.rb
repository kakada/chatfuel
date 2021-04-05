module Api
  module V1
    class SocialProvidersController < ::ActionController::Base
      def create
        social_provider = SocialProvider.new(social_provider_params)

        if social_provider.save
          head :created
        else
          render json: social_provider.errors, status: :unprocessable_entity
        end
      end

      private

      def social_provider_params
        params.require(:social_provider).permit(:provider_name)
      end
    end
  end
end
