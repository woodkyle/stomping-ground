class DistrictsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @districts = District.all
  end

  def show
    @district = District.find(params[:id])
    @reviews = @district.reviews
    @average_rating = 0.0
    @reviews.each do |r|
      @average_rating += r.rating
    end
    @average_rating = @average_rating.fdiv(@reviews.length).round(1)
    if @average_rating.nan?
      @average_rating = 0
    end
    @review = Review.new
  end

  def new
    @district = District.new
  end

  def create
    @district = District.new(district_params)
    @district.user = current_user
    if @district.save
      redirect_to @district
      flash[:success] = "District added successfully"
    else
      @district.errors.any?
      flash[:notice] = @district.errors.full_messages.join(", ")
      render :new
    end
  end

  def destroy
    @district = District.find(params[:id])
    @district.destroy
    flash[:notice] = 'District deleted'
    redirect_to districts_path
  end

  def edit
    @district = District.find(params[:id])
  end

  def update
    @district = District.find(params[:id])
    if @district.update_attributes(district_params)
      redirect_to @district
    else
      render :edit
    end
  end

  protected

  def district_params
    params.require(:district).permit(:name, :description, :avatar)
  end
end
