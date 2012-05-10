class Heypal::Cmspage < Heypal::Base

    def self.getPageContents(params = {})
      result = request("/staticpage/content.json?pageurl=#{params['pageurl']}", :get, params)
      if result['stat'] == 'ok'
          pagecontents = result['pagecontents']
        else
          nil
      end
    end
end