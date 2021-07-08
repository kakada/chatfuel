# Dynamic schedule
Schedule.all.each do |schedule|
  puts "======DO report dynamic schedule======="
  schedule.run!
end
