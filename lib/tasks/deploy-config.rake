
# ####################################################################################
# # APP CONFIGURATION
# ####################################################################################
# NAME    = "foliohouse"

# #-----------------------------------------------------------------------------------
# # SCRIPT SETUP
# #-----------------------------------------------------------------------------------
# DB_PATH   = "mysql2://heypaladmin:HYpl99db@heypal-useast-1.c7xsjolvk9oh.us-east-1.rds.amazonaws.com/"
# EMAILS    = "fer@heypal.com,nico@heypal.com"
# APP       = " --app #{NAME}"
# CONFIRM   = "#{APP} --confirm #{NAME}"
# S3_KEY    = "AKIAJOJEIAZ6LOVHDFDA"
# S3_SECRET = "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"

# #-----------------------------------------------------------------------------------
# # Create new application
# #-----------------------------------------------------------------------------------
# "heroku apps:create #{NAME}"

# #-----------------------------------------------------------------------------------
# # Add addons
# #-----------------------------------------------------------------------------------
# "heroku addons:add deployhooks:email recipient=#{EMAILS} subject=\"[Heroku] {{app}} deployed\" body=\"{{user}} deployed {{head}} to {{url}}\"" + CONFIRM
# "heroku addons:add amazon_rds url=#{DB_PATH}#{NAME}" + CONFIRM
# "heroku addons:add memcachier:25"      + CONFIRM
# "heroku addons:add newrelic:standard"  + CONFIRM
# "heroku addons:add sendgrid:starter"   + CONFIRM
# "heroku addons:add scheduler:standard" + CONFIRM

# #-----------------------------------------------------------------------------------
# # configure addons in the web
# #-----------------------------------------------------------------------------------
# "heroku addons:open sendgrid"   + APP
# # rake places:send_email_alerts
# # rake places:recalculate_prices
# "heroku addons:open scheduler"  + APP

# #-----------------------------------------------------------------------------------
# # Create S3 Bucket
# #-----------------------------------------------------------------------------------
# require 'aws/s3'
# include AWS::S3

# begin
#   Base.establish_connection!(
#     :access_key_id     => S3_KEY,
#     :secret_access_key => S3_SECRET
#   )
#   Bucket.create(NAME)
# rescue Exception => e
#   puts 'Bucket name unavailable, please choose something different than:'
#   buckets = Service.buckets.each {|b| puts "  > " + b.name}
# end

# #-----------------------------------------------------------------------------------
# # Create database
# #-----------------------------------------------------------------------------------
# "heroku run rake db:create db:migrate db:seed" + APP
