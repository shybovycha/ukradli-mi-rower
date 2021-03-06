module BikesApi
  class Bikes < Grape::API
    #version 'v1', using: :path, vendor: 'wiewiórka team'
    format :json
    content_type :json, 'application/json; charset=utf-8'

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

    resource :bikes do
      desc "creates a new bike for user"
      params do
        requires :api_key, type: String, desc: "api key"
        requires :title, type: String, desc: "bike model"
        requires :description, type: String, desc: "bike description"
        optional :images, type: Array
      end
      post do
        authenticate!

        bike = get_user.bikes.new(title: params[:title], description: params[:description])

        errors = []

        unless bike.save
          errors += bike.errors.full_messages
        end

        if params[:images].present?
          params[:images].each do |image|
            if image.is_a? Hash
              bike_img = alert.images.new image: image[:tempfile]
            else
              data = StringIO.new(Base64.decode64(image))
              data.class.class_eval {attr_accessor :original_filename, :content_type}
              data.original_filename = 'img1.jpeg'
              data.content_type = 'image/jpeg'
              bike_img = alert.images.new image: data
            end

            unless bike_img.save
              errors += bike_img.errors.full_messages
            end
          end
        end

        if errors.empty?
          { success: true }
        else
          { success: false, message: errors.join(' and ') }
        end
      end
    end
  end
end