module Schedule::WorkerConcern
  def set_schedule
    Sidekiq.set_schedule(worker, { 'cron' => cron, queue: 'default', 'class' => worker.constantize })
  rescue => error
    puts error.message
  end

  def remove_schedule
    Sidekiq.remove_schedule(worker)
  end

  private

  def worker
    'DoReportNotificationJob'
  end
end
