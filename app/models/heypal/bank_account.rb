class Heypal::BankAccount < Heypal::Base

  set_resource_path '/users/me/bank_accounts.json'

  @@attributes = %w(holder_name holder_street city_id holder_country_code holder_country_name holder_state_name holder_city_name holder_zip id account_number bank_code branch_code iban swift)
  @@attributes.each { |attr| attr_accessor attr.to_sym }

  define_attribute_methods = @@attributes

  validates :holder_name, :holder_street, :holder_city_name, :holder_country_code, :holder_zip, :presence => true

  class << self
    def create(params = {})
      result = request("/users/me/bank_accounts.json", :post, params)

      if result['stat'] == 'ok'
        return get_data_on(result)
      else
        return get_errors_on(result)
      end
    end

    def update(params = {}, access_token)
      result = request("/users/me/bank_accounts/#{params['id']}.json?access_token=#{access_token}", :put, params)
      if result['stat'] == 'ok'
        return get_data_on(result)
      else
        return get_errors_on(result)
      end
    end

    def show(params = {})
      result = request("/users/me/bank_accounts.json?access_token=#{params['access_token']}", :get, params)
      if result['bank_accounts']
        self.new(result['bank_accounts'][0])
      else
        self.new()
      end
    end

    def get_data_on(result)
      [true, result["bank_account"]]
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
      updated, response = self.class.update(self, access_token)
      if updated
        puts [true, response]
        return [true, response]
      else
        puts [false, response]
        return [false, response]
      end
    end
  end

  def new_record?
    self['id'].blank?
  end

end