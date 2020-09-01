module V1
  class Root < Grape::API
    version :v1, :using => :path
    format :json
    rescue_from Grape::Exceptions::Base do
      error!({ error: 'リクエストが不正です(400)' }, 400)
    end
    
    rescue_from :all do
      error!({ error: 'Internal Server Error(500)' }, 500)
    end
    mount V1::Cards

  end
end