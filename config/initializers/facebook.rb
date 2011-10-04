if Rails.env != 'production'
  facebook_settings = YAML.load_file(Rails.root.join('config', 'facebook.yml'))[Rails.env]
  FACEBOOK_APP_ID = facebook_settings['app_id']
  FACEBOOK_SECRET_KEY = facebook_settings['secret_key']
else
  FACEBOOK_APP_ID = ENV['app_id']
  FACEBOOK_SECRET_KEY = ENV['secret_key']
end