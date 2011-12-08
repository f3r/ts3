class Heypal::Address < Heypal::Base

  set_resource_path '/users/me/addresses.json'

  @@attributes = %w(street city country zip id)
  @@attributes.each { |attr| attr_accessor attr.to_sym }

  define_attribute_methods = @@attributes

  validates :street, :city, :country, :zip, :presence => true

  class << self
    def create(params = {})
      result = request("/users/me/addresses.json", :post, params)

      if result['stat'] == 'ok'
        return get_data_on(result)
      else
        return get_errors_on(result)
      end
    end

    def update(params = {}, access_token)
      result = request("/users/me/addresses/#{params['id']}.json?access_token=#{access_token}", :put, params)

      if result['stat'] == 'ok'
        return get_data_on(result)
      else
        return get_errors_on(result)
      end
    end

    def show(params = {})
      result = request("/users/me/addresses.json?access_token=#{params['access_token']}", :get, params)
      if result['addresses']
        self.new(result['addresses'][0])
      else
        self.new()
      end
    end

    def get_data_on(result)
      [true, result["address"]]
    end

    def get_errors_on(result)
      [false, result["err"]]
    end

  end

  def initialize(params = {})
    deserialize(params) if params
    self
  end

  def save(access_token)
    if new_record?
      saved, response = self.class.create(self)

      if saved
        self.deserialize(response)
        return [true, response]
      else
        return [false, response]
      end
    else
      if self.class.update(self, access_token)
        return true
      else
        return false
      end
    end
  end

  def new_record?
    self['id'].blank?
  end

end