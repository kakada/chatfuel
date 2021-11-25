namespace :visitor_count do
  desc "rails 'visitor_count:recalculate[from{DD/MM/YYYY}, duration{in minute}]'"
  task :recalculate, [:from, :duration] => :environment do |task, args|
    puts("Start date is required") || exit if args[:from].blank?
    puts("Duration is required") || exit if args[:duration].blank? || args[:duration].to_i > 0

    visited = Ahoy::Visit.from(args[:from].to_date, [])
    duplicate_ids = visited.duplicate_ids_within_period(duration: args[:duration])

    puts("No duplicate visits found") || exit if duplicate_ids.size.zero?

    puts  "*** PLEASE CONFIRM THAT ***"
    puts  "started_at: #{args[:from]}, grace duration: #{args[:duration]} mins"
    print "Please note that there are #{visited.count - duplicate_ids.size} remains after, "
    print "delete #{duplicate_ids.size} inappropriate visits "
    print "of #{visited.count} total from "
    puts "\"Ahoy::Visit\" & \"Ahoy::Event\" "
    puts  "(Please note that the operation can't be rollback)"
    print "Are you sure?(y/n): "
    confirm = $stdin.gets

    if confirm.strip.downcase == 'y'
      Ahoy::Visit.clear(duplicate_ids)
      puts "Operation committed!"
    else
      puts "Do nothing"
    end
  rescue ArgumentError => e
    puts e.message
  end
end
