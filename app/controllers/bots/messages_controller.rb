module Bots
  class MessagesController < BotsController
    before_action :set_variable, only: :create
    before_action :set_message, only: :create
    before_action :set_step, only: :create

    def create
      head :ok
    end

    def mark_as_completed
      content = TextMessage.find_by(messenger_user_id: params[:messenger_user_id])
      @message = Message.find_by(content: content)
      @message&.completed!
    end

    private
      def set_variable
        variable = Variable.find_or_create_by(name: params[:name])
        
        @variable_value = variable.ensure_value params[:value]
      end

      def set_step
        return if @variable_value.nil?

        @step_value = @message.step_values.find_or_initialize_by(variable: @variable_value.variable)
        @step_value.update(variable_value: @variable_value)
      end
  end
end

