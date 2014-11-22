module BikesApi
  class Users < Grape::API
    #version 'v1', using: :path, vendor: 'wiewiórka team'
    format :json
    #prefix :api

    resource :users do
      desc "registers a user"
      params do
        requires :name, type: String, desc: "user name"
        requires :email, type: String, desc: "email"
        requires :password, type: String, desc: "password"
        requires :password_confirmation, type: String, desc: "password confirmation"
      end
      post :sign_up do
        user = User.new params

        if user.save
          { success: true, api_key: user.api_key }
        else
          { success: false, message: user.errors.full_messages.join(' and ') }
        end
      end

      desc "logs a user in"
      params do
        requires :email, type: String, desc: "email"
        requires :password, type: String, desc: "password"
      end
      post :sign_in do
        user = User.find_by(email: params[:email])

        if user.present? and user.valid_password?(params[:password])
          { success: true, api_key: user.api_key }
        elsif user.blank?
          { success: false, message: "user not found" }
        else
          { success: false, message: "wrong username or password" }
        end
      end

      desc "restores a session"
      params do
        requires :api_key, type: String, desc: "user' API key, stored in a local client's database"
      end
      post :restore_session do
        user = User.find_by(api_key: params[:api_key])

        if user.present?
          { success: true }
        else
          { success: false }
        end
      end
    end
  end
end