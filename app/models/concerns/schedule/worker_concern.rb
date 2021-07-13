module Schedule::WorkerConcern
  def set_schedule
    Sidekiq.set_schedule(worker, { 'cron' => cron, 'class' => worker.constantize })
  rescue => error
    puts error.message
  end

  def remove_schedule
    Sidekiq.remove_schedule(worker)
  end
end
