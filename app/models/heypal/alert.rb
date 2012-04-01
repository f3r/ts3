class Heypal::Alert < Heypal::Base

  set_resource_path '/users/me/alerts.json'

  @@attributes = %w(id user_id alert_type query delivery_method schedule active search_code delivered_at)
  @@attributes.each { |attr| attr_accessor attr.to_sym }
  
  define_attribute_methods = @@attributes

  class << self

    def list(access_token)
      result = request("/users/me/alerts.json?access_token=#{access_token}", :get)
      if result['stat'] == 'ok' && result['alerts']
        return result['alerts']
      else
        return []
      end
    end

    def create(params = {})
      result = request("/users/me/alerts.json", :post, params)

      if result['stat'] == 'ok'
        return get_data_on(result)
      else
        return get_errors_on(result)
      end
    end

    def update(id, access_token, params = {})
      result = request("/users/me/alerts/#{id}.json?access_token=#{access_token}", :put, params)
      if result['stat'] == 'ok'
        return get_data_on(result)
      else
        return get_errors_on(result)
      end
    end

    def delete(id, access_token)
      result = request("/users/me/alerts/#{id}.json?access_token=#{access_token}", :delete)
    end

    def show(id, access_token)
      result = request("/users/me/alerts/#{id}.json?access_token=#{access_token}", :get)
    end

    def get_data_on(result)
      [true, result["alert"]]
    end

    def get_errors_on(result)
      [false, result["err"]]
    end

  end

  # def initialize(params = {})
  #   deserialize(params) if params
  #   self
  # end

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