class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :register, :login ]

  def register
    user = User.new(register_params)
    user.role = "buyer"

    if user.save
      token = generate_token(user)
      render json: { token: token, user: user_response(user) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email]&.downcase)

    if user&.authenticate(params[:password])
      token = generate_token(user)
      render json: { token: token, user: user_response(user) }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def register_params
    params.require(:user).permit(:name, :email, :password)
  end

  def generate_token(user)
    payload = {
      user_id: user.id,
      email: user.email,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, jwt_secret, "HS256")
  end

  def user_response(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role
    }
  end
end
