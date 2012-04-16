class Heypal::Transaction < Heypal::Base

  class << self
    def update(token, params)
      request("/transactions/#{params['id']}.json?access_token=#{token}", :put, :event => params[:event])
    end
  end

end