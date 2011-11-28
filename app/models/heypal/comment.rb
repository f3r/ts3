class Heypal::Comment < Heypal::Base
  set_resource_path '/comments.json'

  @@attributes = %w(comment replying_to)
  @@attributes.each { |attr| attr_accessor attr.to_sym }

  define_attribute_method = @@attributes

  class << self

    def find_all(params)
      result = request("/places/#{params[:place_id]}/comments.json")

      if result["stat"] == 'ok'
        result
      else
        {}
      end
    end

    def get_data_on(result)
      [true, result["comment"]]
    end

    def get_errors_on(result)
      [false, result["err"]]
    end

    def create(params)
      result = request("/places/#{params['place_id']}/comments.json", :post, params)

      if result['stat'] == 'ok'
        return get_data_on(result)
      else
        return get_errors_ond(result)
      end
    end
  end

  def initialize(params = {})
    deserialize(params) if params
    self
  end

  def save
    if new_record?
      saved, response = self.class.create(self)

      if saved
        self.deserialize(response)
        return [true, response]
      else
        return [false, response]
      end
    else
      if self.class.update(self)
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
