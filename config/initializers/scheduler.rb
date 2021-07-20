# Dynamic schedule
if defined? Schedule
  Schedule.find_each do |schedule|
    schedule.set_schedule
  end
end
