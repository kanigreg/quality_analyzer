# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    user = User.find_or_initialize_by(email: auth[:info][:email].downcase)

    unless user.update(user_params)
      redirect_to root_path, alert: t('.failure.update')
    end

    sign_in user
    redirect_to root_path, notice: t('.success')
  end

  def logout
    sign_out
    redirect_to root_path, notice: t('.success')
  end

  private

  def user_params
    {
      nickname: auth[:info][:nickname],
      image_url: auth[:info][:image],
      token: auth[:credentials][:token]
    }
  end

  def auth
    request.env['omniauth.auth']
  end
end
