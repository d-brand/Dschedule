# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
   #before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
   def create
    @user = User.new(sign_up_params)
    render :new and return if params[:back]
     super
 
   end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # 確認画面
  def confirm
    @user = User.new(sign_up_params)
    i = 0
    @password = ""
    while i < @user.password.length
      @password += "*"
      i += 1
    end
  end

  def email_notice
    redirect_to expired_path unless params[:email]
  end

  # 完了画面
  def complete
  end
  
  # # アカウント登録後
  # def after_sign_up_path_for(resource)
  #   users_sign_up_complete_path(resource)
  # end

  # private
  # def registration_params
  #  params.require(:registration).permit(:email, :name, :password, :password_confirmation)
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

   #The path used after sign up.
   def after_inactive_sign_up_path_for(resource)
    users_sign_up_email_notice(email: resource.email)
   end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
