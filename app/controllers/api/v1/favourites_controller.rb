class Api::V1::FavouritesController < ApplicationController
  def index
    favourites = current_user.properties
    render json: favourites, status: :ok
  end

  def create
    property = Property.find(params[:property_id])
    favourite = current_user.favourites.build(property: property)

    if favourite.save
      render json: { message: "Property added to favourites" }, status: :created
    else
      render json: { errors: favourite.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Property not found" }, status: :not_found
  end

  def destroy
    favourite = current_user.favourites.find_by(property_id: params[:id])

    if favourite
      favourite.destroy
      render json: { message: "Property removed from favourites" }, status: :ok
    else
      render json: { error: "Favourite not found" }, status: :not_found
    end
  end
end
