namespace :visitor do
  desc "Clear ahoy visitor count"
  task :remove_data_before, [:dashboard_launch_date] => :environment do |t, args|
    ActiveRecord::Base.transaction do
      dashboard_launch_date = args[:dashboard_launch_date].to_date
      dashboard_launch_date = dashboard_launch_date.strftime("%Y/%m/%d")

      puts  "*** PLEASE CONFIRM THAT ***"
      print "You want to delete data from "
      print "\"Ahoy::Visit\" & \"SocialProvider\" "
      puts  "before #{dashboard_launch_date}"
      puts  "(Please note that the operation can't be rollback)"
      print "Are you sure?(y/n): "
      confirm = $stdin.gets

      if confirm.strip.downcase == 'y'
        Ahoy::Visit.where("DATE(started_at) < ?", dashboard_launch_date).destroy_all
        SocialProvider.where("DATE(created_at) < ?", dashboard_launch_date).destroy_all
        puts "Operation committed!"
      else
        puts "Do nothing"
      end

    rescue => e
      puts e.message
    end
  end
end
