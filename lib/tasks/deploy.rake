namespace :deploy do
  def cmd(c)
    puts c
    #system(c) || fail("Error")
    puts
  end

  APP = ENV['APP'] || 'squarestage'

  task :full => [:push_config, :push, :migrate, :after_migrate, :restart]

  task :quick => [:push]

  task :push do
    puts 'Deploying site to Heroku ...'
    cmd "git push #{APP} master --force"
  end
  
  task :push_config do
    puts 'Pushing configuration ...'
    cmd "rake #{APP} heroku:config"
  end

  task :restart do
    puts 'Restarting app servers ...'
    cmd "heroku restart --app #{APP}"
  end
  
  task :migrate do
    puts 'Running database migrations ...'
    cmd "heroku run rake db:migrate --app #{APP}"
  end
  
  task :after_migrate do
    puts 'Loading new translations ...'
    cmd "heroku run rake i18n:populate:from_rails --app #{APP}"
  end

  task :off do
    puts 'Putting the app into maintenance mode ...'
    cmd "heroku maintenance:on --app #{APP}"
  end
  
  task :on do
    puts 'Taking the app out of maintenance mode ...'
    cmd "heroku maintenance:off --app #{APP}"
  end
end