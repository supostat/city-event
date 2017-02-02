namespace :local_users do
  desc "Pulls all city users, you should only need to do this once."
  task :pull_city_users => :environment do
    puts 'Pulling City users'
    CityUser.pull_city_users
    puts 'Done pulling city users'
  end

  desc 'Destroys all city users'
  task :destroy_city_users => :environment do
    puts 'Destroying ALL city users now'
    CityUser.destroy_all
    puts 'Done!'
  end

  desc 'Updates all city users. This is the task you want to usually use.'
  task :update_city_users => :environment do
    puts 'Updating ALL city users now'
    CityUser.update_city_users
    puts 'Done!'
  end
end
