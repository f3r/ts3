require File.dirname(__FILE__) + '/../i18n_util.rb'

namespace :i18n do

  namespace :populate do

    desc 'Populate the locales and translations tables from all Rails Locale YAML files. Can set LOCALE_YAML_FILES to comma separated list of files to overide'
    task :from_rails => :environment do
      yaml_files = ENV['LOCALE_YAML_FILES'] ? ENV['LOCALE_YAML_FILES'].split(',') : I18n.load_path
      yaml_files.find_all{|file|File.extname(file) == '.yml'}.each do |file|
        I18nUtil.load_from_yml file
      end
    end


    # desc 'Create translation records from all default locale translations if none exists.'
    # task :synchronize_translations => :environment do
    #   I18nUtil.synchronize_translations
    # end
    # 
    # desc 'Populate default locales'
    # task :load_default_locales => :environment do
    #   I18nUtil.load_default_locales(ENV['LOCALE_FILE'])
    # end

  end

end
