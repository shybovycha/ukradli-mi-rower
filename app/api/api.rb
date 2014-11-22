class API < Grape::API
  prefix :api

  mount BikesApi::Alerts
  mount BikesApi::Bikes
  mount BikesApi::Users
end