namespace :deploy do
  APP       = ENV['APP'] || 'squarestage'
  APP_SETUP = "--app #{APP}"
  CONFIRM   = "#{APP_SETUP} --confirm #{APP}"
  DB_PATH   = "mysql2://heypaladmin:HYpl99db@heypal-useast-1.c7xsjolvk9oh.us-east-1.rds.amazonaws.com/"
  EMAILS    = "fer@heypal.com,nico@heypal.com"

  task :full => [:push_config, :push, :migrate, :after_migrate, :restart]

  task :quick => [:push]

  task :push do
    header 'Deploying site to Heroku ...'
    if %x[git status|grep "working directory clean"|wc -l].to_i == 1
      cmd "git push #{APP} HEAD:master --force"
    else
      puts "Please commit all your changes before pushing!"
    end
  end

  task :push_config do
    header 'Pushing configuration ...'
    cmd "rake #{APP} heroku:config"
  end

  task :restart do
    header 'Restarting app servers ...'
    cmd "heroku restart #{APP_SETUP}"
  end

  task :migrate do
    header 'Running database migrations ...'
    cmd "heroku run rake db:migrate #{APP_SETUP}"
  end

  task :after_migrate do
    header 'Loading new translations ...'
    cmd "heroku run rake i18n:populate:from_rails #{APP_SETUP}"
  end

  task :off do
    header 'Putting the app into maintenance mode ...'
    cmd "heroku maintenance:on #{APP_SETUP}"
  end

  task :on do
    header 'Taking the app out of maintenance mode ...'
    cmd "heroku maintenance:off #{APP_SETUP}"
  end

  task :new_site => [:new_app_heroku, :addons, :addons_open_browser, :new_s3_bucket, :new_database]

  task :new_app_heroku do
    header 'Creating new site infrastructure'
    header_subsection 'Creating app in heroku'
    cmd "heroku apps:create #{APP}"
  end

  task :addons do
    header_subsection 'Adding Heroku Addons'
    cmd "heroku addons:add deployhooks:email --recipient=#{EMAILS} --subject=\"[Heroku] {{app}} deployed\" --body=\"{{user}} deployed {{head}} to {{url}}\" #{CONFIRM}"
    cmd "heroku addons:add amazon_rds url=#{DB_PATH}#{APP} #{CONFIRM}"
    cmd "heroku addons:add memcachier:25 #{CONFIRM}"
    cmd "heroku addons:add newrelic:standard #{CONFIRM}"
    cmd "heroku addons:add sendgrid:starter #{CONFIRM}"
    cmd "heroku addons:add scheduler:standard #{CONFIRM}"
  end

  task :addons_open_browser do
    # configure addons in the web
    header_subsection 'Configure Addons (open in browser)'
    cmd "heroku addons:open sendgrid #{APP_SETUP}"
    # rake places:send_email_alerts
    # rake places:recalculate_prices
    cmd "heroku addons:open scheduler #{APP_SETUP}"
  end

  task :new_s3_bucket do
    header_subsection 'Creating Amazon S3 buckets'
    begin
      s3 = AWS::S3.new(:access_key_id => S3_ACCESS_KEY_ID, :secret_access_key => S3_SECRET_ACCESS_KEY)
      bucket = s3.buckets.create(APP)
      puts " > Bucket #{APP} successfully created".light_blue
      # TODO: check whether buckets are public or private
    rescue Exception => e
      puts("[ERROR] #{e.message}".red)
      s3.buckets.each {|b| puts("  > #{b.name}".red) }
    end
  end

  task :new_database do
    header_subsection 'Creating database in RDS'
    cmd "heroku run rake db:create #{APP_SETUP}"
  end

  task :new_database_setup do
    header_subsection 'Importing schema in db & creating initial data'
    cmd "heroku run rake db:migrate #{APP_SETUP}"
    cmd "heroku run rake db:seed #{APP_SETUP}"
  end

private
  def cmd(c)
    puts(" > #{c}".light_blue)
    system(c) || fail("Error")
  end

  # TODO: Add colors
  def header(m)
    puts("*".blue*80)
    puts("*#{m.chomp.center(78)}*".blue)
    puts("*".blue*80)
  end

  def header_subsection(m)
    puts
    puts("-".cyan*80)
    puts("|#{m.chomp.center(78)}|".cyan)
    puts("-".cyan*80)
  end
end