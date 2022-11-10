class ApplicationController < ActionController::Base
  before_action :kiyaku
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :team_name,only: [:after_sign_in_path]
 
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  #rescue_from Exception, with: :render_500

  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name]) # 新規登録時(sign_up時)にnameというキーのパラメーターを追加で許可する
  end

  def after_sign_in_path_for(resource) 
    if resource.admin == true
      return admin_users_path
    end

    #team名取得
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
    
    if resource.sign_in_count == 1
      if Teamcore.find_by(user_id:current_user.id)
        return   schedules_path(teamcores_teamname: @team.teamname)
      else
        return   new_team_path
      end
    end

    
    schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd)
    if schedules.present?
      workschedule =schedules.first
      return schedule_path(id: workschedule.id, teamcores_teamname: @team.teamname) # ログイン後に遷移するpathを設定
    end
    schedules_path(teamcores_teamname: @team.teamname)# ログイン後に遷移するpathを設定
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
  
  def kiyaku
    kiyaku_index_path
  end
  
  def render_404
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end
  
  def render_500
    render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end
end
