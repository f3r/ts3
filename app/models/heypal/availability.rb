class Heypal::Availability < Heypal::Base

  set_resource_path '/availabilities.json'

  @@attributes = %w(availability_type date_start end_start price_per_night comment)
  @@attributes.each { |attr| attr_accessor attr.to_sym }

  define_attribute_methods = @@attributes

  class << self
    def create(params = {})

    end
  end
end
