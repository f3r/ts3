class Heypal::Message < Heypal::Base

  class << self
    def list(params = {})
      request("/conversations.json?access_token=#{params['access_token']}", :get, params)
    end

    def messages(params = {})
      request("/messages/#{params['id']}.json?access_token=#{params['access_token']}", :get, params)
    end

    def create(params = {})
      result = request("/messages/#{params[:id]}.json", :post, params)
      
      if result['stat'] == 'ok'
        return get_data_on(result)
      else
        return get_errors_on(result)
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