# To use the Bootstrap Rake task for you own application create
# yaml files in db/bootstrap containing your data.
#
# E.g. to fill the 'users' table, create the yaml file db/bootstrap/users.yml
# 
# Next, run 'rake db:bootstrap' to re-initialize your database.
#
namespace :db do
  desc "Recreates the development database and loads the bootstrap fixtures from db/boostrap."
  task :bootstrap do |task_args|
    mkdir_p File.join(RAILS_ROOT, 'log')
    
    require 'rubygems' unless Object.const_defined?(:Gem)
        
    %w(environment db:drop db:create db:migrate db:bootstrap:load tmp:create).each { |t| Rake::Task[t].execute task_args}

  end
  
  namespace :bootstrap do
    desc "Load fixtures from db/bootstrap into the database"
    task :load => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db', 'bootstrap', '*.{yml,csv}'))).each do |fixture_file|
        Fixtures.create_fixtures('db/bootstrap', File.basename(fixture_file, '.*'))
      end
    end
  end
end