class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :team_name,only: [:after_sign_in_path]

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name]) # 新規登録時(sign_up時)にnameというキーのパラメーターを追加で許可する
  end

  def after_sign_in_path_for(resource)
    if resource.admin == true
      return admin_users_path
    end

    if resource.sign_in_count == 1
      if Teamcore.find_by(user_id:current_user.id)
        return   schedules_path
      else
        return   new_team_path
      end
    end
    schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd)
    if schedules.present?
      workschedule =schedules.first
      return schedule_path(workschedule.id) # ログイン後に遷移するpathを設定
    end
    schedules_path# ログイン後に遷移するpathを設定
  end

  def after_sign_out_path_for(resource)
    new_user_session_path # ログアウト後に遷移するpathを設定
  end

  def team_name
    if user_signed_in?
      isAdmin= User.find_by(id:current_user.id)
      if !isAdmin.admin?
        @team =Teamcore.find_by(user_id:current_user.id)     
      else
        @team="master"
      end
    else
      @team= Teamcore.find_by(access_token: session[:access_token] )
    end
  end
end
