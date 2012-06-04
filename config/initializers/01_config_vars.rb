# LOAD LOCAL CONFIGURATION
if Rails.env.test? || Rails.env.development?
  APP_CONFIG = YAML.load_file("#{Rails.root}/config/local.yml")[Rails.env]
else
  APP_CONFIG = {}
end

# SET VARIABLES, DEVELOPMENT, TEST FALLBACKS
S3_ACCESS_KEY_ID =      ENV['S3_ACCESS_KEY_ID']       || APP_CONFIG['S3_ACCESS_KEY_ID']
S3_SECRET_ACCESS_KEY =  ENV['S3_SECRET_ACCESS_KEY']   || APP_CONFIG['S3_SECRET_ACCESS_KEY']
S3_BUCKET =             ENV['S3_BUCKET']              || APP_CONFIG['S3_BUCKET']
FB_APP_ID =             ENV['FB_APP_ID']              || APP_CONFIG['FB_APP_ID']
FB_APP_SECRET =         ENV['FB_APP_SECRET']          || APP_CONFIG['FB_APP_SECRET']
TW_APP_ID =             ENV['TW_APP_ID']              || APP_CONFIG['TW_APP_ID']
TW_APP_SECRET =         ENV['TW_APP_SECRET']          || APP_CONFIG['TW_APP_SECRET']
FRONTEND_PATH =         ENV['FRONTEND_PATH']          || APP_CONFIG['FRONTEND_PATH']
BACKEND_PATH =          ENV['BACKEND_PATH']           || APP_CONFIG['BACKEND_PATH']
SECRET_TOKEN =          ENV['SECRET_TOKEN']           || APP_CONFIG['SECRET_TOKEN']
COOKIE_STORE_KEY =      ENV['COOKIE_STORE_KEY']       || APP_CONFIG['COOKIE_STORE_KEY']
MAILER_SENDER =         ENV['MAILER_SENDER']          || APP_CONFIG['MAILER_SENDER']
PEPPER_TOKEN =          ENV['PEPPER_TOKEN']           || APP_CONFIG['PEPPER_TOKEN']
SUPPORT_EMAIL =         ENV['SUPPORT_EMAIL']          || APP_CONFIG['SUPPORT_EMAIL']
PAYPAL_ACCOUNT =        ENV['PAYPAL_ACCOUNT']         || APP_CONFIG['PAYPAL_ACCOUNT']
PAYPAL_MODE =           ENV['PAYPAL_MODE']            || APP_CONFIG['PAYPAL_MODE']
RECAPTCHA_PUB_KEY =     ENV['RECAPTCHA_PUB_KEY']      || APP_CONFIG['RECAPTCHA_PUB_KEY']
RECAPTCHA_PVT_KEY =     ENV['RECAPTCHA_PVT_KEY']      || APP_CONFIG['RECAPTCHA_PVT_KEY']
MAIL_BCC =              ENV['MAIL_BCC']               || APP_CONFIG['MAIL_BCC']
GAE_TRACKING_CODE =     ''
SITE_URL =              FRONTEND_PATH
SITE_TAGLINE =          ENV['SITE_TAGLINE']           || APP_CONFIG['SITE_TAGLINE']
SITE_DOMAIN =           ENV['SITE_DOMAIN']            || APP_CONFIG['SITE_DOMAIN']
RAKISMET_KEY =          ENV['RAKISMET_KEY']           || APP_CONFIG['RAKISMET_KEY']
RAKISMET_URL =          ENV['RAKISMET_URL']           || APP_CONFIG['RAKISMET_URL']
