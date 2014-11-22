class API < Grape::API
  prefix :api

  mount BikesApi::Bikes
  mount BikesApi::Users
end