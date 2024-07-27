Rails.application.routes.draw do
  post '/url/encode', to: 'short_links#encode'
  post '/url/decode', to: 'short_links#decode'
end
