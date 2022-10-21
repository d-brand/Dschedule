class TeamController < ApplicationController
  before_action :authenticate_user!
  #before_action :teamname

  def index
    begin
      @title ="グループ情報"
      @teamInfo=Teamcore.find_by(user_id:current_user.id)
      @userInfo=User.find(current_user.id)
    rescue LoadError
      p "一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      p "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
     end
  end

  def new
    @teamCreate=Teamcore.new
  end
  
  def edit
    @team=Teamcore.find(params[:id])
  end
  
  def show
    @title="グループ詳細"
    @teamShow=Teamcore.find(params[:id])
  end
  
  def create
    begin
      @schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd)
      @workschedule =@schedules.first
      
      if request.post? then
        team=Teamcore.create(team_params)
      end
      redirect_to :action=>"index", :controller=>"schedules"
      #team_path(team)
    rescue LoadError
      p "一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      p "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end

  end

  def update
    begin
      @schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd)
      @workschedule =@schedules.first
      
      @team=Teamcore.find(params[:id])
      if @team.update(team_params)
        redirect_to :action=>"index", :controller=>"schedules", notice: 'グループ名が更新されました。' 
      else
        redirect_to :action=>"index", :controller=>"schedules"
      end
    rescue LoadError
      p "一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      p "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end
  end


  private
  def team_params
    params.require(:teamcore).permit(:teamname,:user_id)
  end

end

