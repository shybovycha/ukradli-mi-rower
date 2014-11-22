module BikesApi
  class Alerts < Grape::API
    #version 'v1', using: :path, vendor: 'wiewiórka team'
    format :json
    content_type :json, 'application/json; charset=utf-8'

    module Entities
      # User entity
      class User < Grape::Entity
        expose :name
      end

      # Base entity
      class Alert < Grape::Entity
        format_with(:iso_timestamp) { |dt| dt.iso8601 }

        expose :id
        expose :title
        expose :description
        expose :lat
        expose :lon

        expose :user, as: :author, using: User

        expose :images do |alert|
          alert.images.map { |e| e.image.url }
        end

        with_options(format_with: :iso_timestamp) do
          expose :created_at
        end

        def self.format(collection)
          collection.map { |e| Entities::LostAlert.new(e) }
        end
      end

      # FoundAlert entity
      class FoundAlert < Alert
        with_options(format_with: :iso_timestamp) do
          expose :created_at
        end

        def self.format(collection)
          collection.map { |e| Entities::FoundAlert.new(e) }
        end
      end

      # LostAlert entity
      class LostAlert < Alert
        expose :found_alerts, using: FoundAlert

        with_options(format_with: :iso_timestamp) do
          expose :created_at
        end

        def self.format(collection)
          collection.map { |e| Entities::LostAlert.new(e) }
        end
      end
    end

    helpers do
      def get_user
        unless @current_user.present?
          if params[:api_key].present?
            @current_user = User.find_by(api_key: params[:api_key])
          end
        end

        @current_user
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless get_user
      end
    end

    resource :alerts do
      desc "creates a new lost alert"
      params do
        requires :api_key, type: String, desc: "api key"
        requires :title, type: String, desc: "title (bike model)"
        requires :description, type: String, desc: "description (bike description)"
        requires :lat, type: Float, desc: "latitude"
        requires :lon, type: Float, desc: "longitude"
      end
      post :lost do
        authenticate!

        alert = get_user.lost_alerts.new(title: params[:title], description: params[:description], lat: params[:lat], lon: params[:lon])
        alert.images = get_user.bikes.first.images

        if alert.save
          { success: true }
        else
          { success: false, message: alert.errors.full_messages.join(' and ') }
        end
      end

      desc "creates a new lost alert"
      params do
        requires :api_key, type: String, desc: "api key"
        requires :lost_alert_id, type: Integer, desc: "lost alert id"
        requires :title, type: String, desc: "bike model"
        requires :description, type: String, desc: "bike description"
        requires :lat, type: Float, desc: "latitude"
        requires :lon, type: Float, desc: "longitude"
      end
      post :found do
        authenticate!

        parent_alert = LostAlert.find(params[:lost_alert_id])

        unless parent_alert.present?
          error!({ success: false, message: "wrong lost alert id" })
        end

        alert = get_user.found_alerts.new(title: params[:title], description: params[:description], lat: params[:lat], lon: params[:lon])

        alert.lost_alert = parent_alert

        if alert.save
          { success: true }
        else
          { success: false, message: alert.errors.full_messages.join(' and ') }
        end
      end

      desc "get lost alerts list"
      get :lost do
        alerts = LostAlert.all

        { success: true, alerts: Entities::LostAlert.format(alerts) }
      end

      desc "get lost alerts list"
      get 'lost/:id' do
        alert = LostAlert.find(params[:id])

        if alert.present?
          { success: true, alert: alert }
        else
          { success: false, message: "wrong lost alert id" }
        end
      end
    end
  end
end