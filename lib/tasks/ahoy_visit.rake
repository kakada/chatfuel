namespace :ahoy_visit do
  desc "Clear ahoy visitor count"
  task clear: :environment do
    ActiveRecord::Base.transaction do
      raise "Must specify PUBLIC_DASHBOARD_LAUNCH_DATE" unless ENV["PUBLIC_DASHBOARD_LAUNCH_DATE"].present?

      puts  "*** PLEASE CONFIRM THAT ***"
      print "You want to delete data from "
      print "\"Ahoy::Visit\" & \"SocialProvider\" "
      puts  "before #{ENV["PUBLIC_DASHBOARD_LAUNCH_DATE"]}"
      puts  "(Please note that the operation can't be rollback)"
      print "Are you sure?(y/n): "
      confirm = $stdin.gets

      if confirm.strip.downcase == 'y'
        Ahoy::Visit.where("DATE(started_at) < ?", ENV["PUBLIC_DASHBOARD_LAUNCH_DATE"]).destroy_all
        SocialProvider.where("DATE(created_at) < ?", ENV["PUBLIC_DASHBOARD_LAUNCH_DATE"]).destroy_all
        puts "Operation committed!"
      else
        puts "No operation!"
      end
    end
  end
end
