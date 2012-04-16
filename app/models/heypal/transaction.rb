class Heypal::Transaction < Heypal::Base

  class << self
    def update(token, params)
      request("/transactions/#{params['id']}.json?access_token=#{token}", :put, params.slice(:event))
    end

    def pay(code, params)
      request("/transactions/#{code}/pay.json", :post, params.slice(:amount))
    end
  end

end