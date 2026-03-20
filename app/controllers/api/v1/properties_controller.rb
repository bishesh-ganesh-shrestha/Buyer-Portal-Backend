class Api::V1::PropertiesController < ApplicationController
  def index
    properties = Property.all
    render json: properties_with_favourites(properties), status: :ok
  end

  def show
    property = Property.find(params[:id])
    render json: property, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Property not found" }, status: :not_found
  end

  private

  def properties_with_favourites(properties)
    favourited_ids = current_user.favourites.pluck(:property_id)

    properties.map do |property|
      property.as_json.merge(favourited: favourited_ids.include?(property.id))
    end
  end
end
