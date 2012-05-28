require 'i18n/backend/active_record'
class I18nUtil

  # Create tanslation records from the YAML file.  Will create the required locales if they do not exist.
  def self.load_from_yml(file_name)
    data = YAML::load(IO.read(file_name))
    data.each do |code, translations| 
      if locale = I18n.available_locales.include?(code.to_sym) ? code : nil
        translations_array = extract_translations_from_hash(translations)
        translations_array.each do |key, value|
          pluralization_index = 1
          key.gsub!('.one', '') if key.ends_with?('.one')
          if key.ends_with?('.other')
            key.gsub!('.other', '')
            pluralization_index = 0
          end
          if value.is_a?(Array)
            value.each_with_index do |v, index|
              create_translation(locale, key, index, v) unless v.nil?
            end
          else
            create_translation(locale, key, pluralization_index, value)
          end
        end
      else
        puts "WARNING: Locale not found: #{code} -- #{file_name}"
      end
    end
  end

  # Finds or creates a translation record and updates the value
  def self.create_translation(locale, key, pluralization_index, value)
    translation = Translation.find_by_locale_and_key(locale, key) # find existing record by hash key
    unless translation # or build new one with raw key
      translation = Translation.new(:locale => locale, :key => key)
      puts "from yaml create translation for #{locale} : #{key}" unless Rails.env.test?
    end
    translation.value = value
    translation.save!
  end

  def self.extract_translations_from_hash(hash, parent_keys = [])
    (hash || {}).inject([]) do |keys, (key, value)|
      full_key = parent_keys + [key]
      if value.is_a?(Hash)
        # Nested hash
        keys += extract_translations_from_hash(value, full_key)
      elsif !value.nil?
        # String leaf node
        keys << [full_key.join("."), value]
      end
      keys
    end
  end

end