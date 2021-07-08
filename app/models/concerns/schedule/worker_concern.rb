module Schedule::WorkerConcern
  def run!
    return unless ready?
    Sidekiq.set_schedule(worker, { 'cron' => cron, 'class' => worker.constantize })
  rescue => error
    puts error.message
  end
end
