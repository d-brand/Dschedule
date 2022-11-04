class TeamController < ApplicationController
  before_action :authenticate_user!
  #before_action :teamname

  def index
    begin
      @title ="グループ情報"
      @teamInfo=Teamcore.find_by(user_id:current_user.id)
      @userInfo=User.find(current_user.id)
    rescue LoadError
      render plain:"一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      prender plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
     end
  end

  def new
    @teamCreate=Teamcore.new
  end
  
  def edit
    @team=Teamcore.find(params[:id])
    @teamtoken=@team.set_access_token
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
      else
        flash[:notice] = "グループ名が空欄です。必ず入力してください。"
        render :new
      end

      redirect_to :action=>"index", :controller=>"schedules"
      #team_path(team)
    rescue LoadError
      render plain:"一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain:"システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end

  end

  def update
    begin
      @schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd)
      @workschedule =@schedules.first
      
      @team=Teamcore.find(params[:id])
      if @team.update(team_params)
        redirect_to :action=>"index", :controller=>"schedules" 
      else
        flash[:notice] = "グループ名が空欄です。必ず入力してください。"
        redirect_to edit_team_path(@team)
      end
   rescue LoadError
      render plain:"一度ブラウザを閉じて再度お試してください。"
    rescue ActiveRecord::RecordNotFound => e
      redirect_to edit_team_path(@team), notice: '先ほどアクセスしたページは存在しませんでした。'
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain:"システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end
  end

  def token_generte
    @team=Teamcore.find(params[:id])
    @update_token=@team.generate_access_token
    logger.debug "-------"
    logger.debug @update_token.inspect
    logger.debug "-------"
    if Teamcore.update(access_token: @update_token)
      flash[:notice] = "グループURLが変更されました"
      redirect_to :action=>"index", :controller=>"schedules"
    end
  end

  private
  def team_params
    params.require(:teamcore).permit(:teamname,:user_id)
  end
  def teamtoken_params
    params.require(:teamcore).permit(:user_id,:access_token)
  end

end

