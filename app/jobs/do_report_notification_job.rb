class DoReportNotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "******** DO report notification [#{DateTime.current}] **********"
    # broadcast pdf
  end
end
