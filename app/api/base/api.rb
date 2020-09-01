# app/api/base/api.rb
module Base
  class API < Grape::API
    
    route :any, '*path' do
      error!({ error: 'not_found・URLが不正です(404)' }, 404)
    end
    mount V1::Root
  end
end