class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last
    begin
      decoded = JWT.decode(token, jwt_secret, true, algorithm: "HS256")
      @current_user = User.find(decoded[0]["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def jwt_secret
    ENV.fetch("JWT_SECRET", "dev_secret_key")
  end

  def current_user
    @current_user
  end
end
