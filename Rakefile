# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :grape do
  desc "API Routes"
  task :routes => :environment do
    [ BikesApi::Bikes, BikesApi::Users ].each do |api_class|
      api_class.routes.each do |api|
        method = api.route_method.ljust(10)
        path = api.route_path
        puts "     #{method} #{path}"
      end
    end
  end
end