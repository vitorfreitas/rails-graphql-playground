class AuthenticationController < ApplicationController
  def login
    user = User.find_by_username!(login_params[:username])

    if user.authenticate(login_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end
