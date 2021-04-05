class QuotasController < PrivateAccessController
  def index
    @quota = Quotum.last
    @queue = Sidekiq::ScheduledSet.new
    @connection_count = TextMessage.distinct.count(:messenger_user_id)
  end
end
