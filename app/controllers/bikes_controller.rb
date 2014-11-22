class BikesController < ApplicationController
  before_action :set_bike, only: [:show, :edit, :update, :destroy]

  # GET /bikes
  def index
    @bikes = Bike.all
  end

  # GET /bikes/1
  def show
  end

  # GET /bikes/new
  def new
    @bike = Bike.new
  end

  # GET /bikes/1/edit
  def edit
  end

  # POST /bikes
  def create
    @bike = Bike.new(bike_params)

    if @bike.save
      redirect_to @bike, notice: 'Bike was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bikes/1
  def update
    if @bike.update(bike_params)
      redirect_to @bike, notice: 'Bike was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bikes/1
  def destroy
    @bike.destroy
    redirect_to bikes_url, notice: 'Bike was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bike
      @bike = Bike.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bike_params
      params.require(:bike).permit(:title, :description)
    end
end
