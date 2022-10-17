class TeamController < ApplicationController
  before_action :authenticate_user!
  #before_action :teamname

  def index
    @title ="グループ情報"
    @teamInfo=Teamcore.find_by(user_id:current_user.id)
    @userInfo=User.find(current_user.id)
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
    @schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd)
    @workschedule =@schedules.first
    
    if request.post? then
      team=Teamcore.create(team_params)
    end
    redirect_to :action=>"index", :controller=>"schedules"
    #team_path(team)
  end

  def update
    @schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd)
    @workschedule =@schedules.first
    
    @team=Teamcore.find(params[:id])
    if @team.update(team_params)
      redirect_to :action=>"index", :controller=>"schedules", notice: 'グループ名が更新されました。' 
    else
      redirect_to :action=>"index", :controller=>"schedules"
    end
  end


  private
  def team_params
    params.require(:teamcore).permit(:teamname,:user_id)
  end

end

