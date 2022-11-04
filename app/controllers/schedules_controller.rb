class SchedulesController < ApplicationController
  before_action :set_token,if: :login_kaku
  before_action :token_check,if: :login_kaku
  before_action :set_schedule, only: [:index,:show]
  before_action :update_set_schedule, only: [:edit, :update, :destroy]
  before_action :team_name
 
  # GET /schedules
  # GET /schedules.json
  def index
   begin 
      if @workguest.present?
        @team= Teamcore.find_by(access_token: session[:access_token] )
        @schedules = @team.schedules.where(" schedules.ymd > ?",Time.current.yesterday).reorder(:ymd)
        @workschedule = @schedules.first
      else
        @schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd)
        @workschedule =@schedules.first
      end
      if @workschedule.present?
        @answers_sanka = @workschedule.answers.where("reason =?",'sanka')
        @answers_tabun = @workschedule.answers.where("reason =?",'tabun')
        @answers_mitei = @workschedule.answers.where("reason =?",'mitei')
        @answers_kesseki =  @workschedule.answers.where("reason =?",'kesseki')
      end
      @answer = Answer.new
      @answer.schedule_id = params[:id]
    rescue LoadError
      render plain: "一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end
    
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
    begin     
      if @workguest.present?
        @team= Teamcore.find_by(access_token: session[:access_token] )
        @schedules = @team.schedules.where(" schedules.ymd > ?",Time.current.yesterday).reorder(:ymd)
        @workschedule = @schedules.first
      else
        @schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd)
        @workschedule = @schedules.first 
      end
      
      if @workschedule.present?
        @answers_sanka = @workschedule.answers.where("reason =?",'sanka')
        @answers_tabun = @workschedule.answers.where("reason =?",'tabun')
        @answers_mitei = @workschedule.answers.where("reason =?",'mitei')
        @answers_kesseki =  @workschedule.answers.where("reason =?",'kesseki')
      end
      
      if @workschedule.present?
        if params[:id]
            schedule = Schedule.find(params[:id])
            @answers_sanka =  schedule.answers.where("reason =?",'sanka')
            @answers_tabun =  schedule.answers.where("reason =?",'tabun')
            @answers_mitei =  schedule.answers.where("reason =?",'mitei')
            @answers_kesseki =  schedule.answers.where("reason =?",'kesseki')
        else
            schedule = Schedule.uketsukechu.order(ymd: :asc).first
            @answers_sanka =  schedule.answers.where("reason =?",'sanka')
            @answers_tabun =  schedule.answers.where("reason =?",'tabun')
            @answers_mitei =  schedule.answers.where("reason =?",'mitei')
            @answers_kesseki =  schedule.answers.where("reason =?",'kesseki')
        end
      end

      @answer = Answer.new
      @answer.schedule_id = params[:id]
      if current_user.present?
        #@caution = '※チーム毎でサイト管理している為、パスワードを設けておりません。チーム幹事のみ編集してください。'
      end
    rescue LoadError
      render plain: "一度ブラウザを閉じて再度お試してください。"

    rescue ActiveRecord::RecordNotFound => e
      redirect_to schedules_path, notice: '先ほどアクセスしたページは存在しませんでした。'

    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end
  end

  # GET /schedules/kiyaku
  def kiyaku
  end
  
  # GET /schedules/new
  def new
    begin
      @schedules = Schedule.where("schedules.user_id=? ",current_user.id,).reorder(:ymd)
      @schedule = Schedule.new

      if @schedules.present?
        @kizonschedule = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd).first
          if !@kizonschedule.present?
            @kizonschedule = 0
          end
      else
        @kizonschedule = 0
      end
      logger.debug "--------"
      logger.debug @kizonschedule.inspect
      logger.debug "--------"
    rescue LoadError
      render plain: "一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      p "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end

  end
  
  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules
  # POST /schedules.json
  def create
    begin
      @schedule = Schedule.new(schedule_params)

      respond_to do |format|
        if @schedule.save
          format.html { redirect_to new_schedule_path, notice: 'スケジュールが作成されました。' }
          format.json { render :show, status: :created, location: @schedule }
        else
          format.html { redirect_to new_schedule_path, notice: '開催場所、もしくは詳細が記載されていません。' }
          format.json { render json: @schedule.errors, status: :unprocessable_entity }
        end
      end
    rescue LoadError
      render plain: "一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end

  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update
    begin
      respond_to do |format|
        if @schedule.update(schedule_params)
          format.html { redirect_to new_schedule_path, notice: 'スケジュールが更新されました。' }
          format.json { render :show, status: :ok, location: @schedule }
        else
          format.html { render :edit }
          format.json { render json: @schedule.errors, status: :unprocessable_entity }
        end
      end
    
    rescue LoadError
      render plain: "一度ブラウザを閉じて再度お試してください。"
    rescue ActiveRecord::RecordNotFound => e
      redirect_to edit_schedule_path(@schedule), notice: '先ほどアクセスしたページは存在しませんでした。'
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain:"システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    begin
      @schedule.destroy
      respond_to do |format|
        format.html { redirect_to new_schedule_path, notice: 'スケジュールが削除されました。' }
        format.json { head :no_content }
      end
    rescue LoadError
      render plain: "一度ブラウザを閉じて再度お試してください。"

    rescue ActiveRecord::RecordNotFound => e
      redirect_to schedule_path(@schedule), notice: '先ほどアクセスしたページは存在しませんでした。'

    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain:"システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      begin
        @guest_user="ゲストログイン"
        @schedule = if params[:id].blank?
          #Schedule.uketsukechu.first
          if current_user.present?
            Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd).first
          else
            @unsighn_team=Teamcore.find_by(access_token:session[:access_token] )
            @guest_user=@unsighn_team
            @workguest="ゲストログイン"     
            Schedule.where("schedules.user_id=? and schedules.ymd > ?",@guest_user.user_id,Time.current.yesterday).reorder(:ymd).first        
          end
        else
          #Schedule.find(params[:id])
          if current_user.present?
            @schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",current_user.id,Time.current.yesterday).reorder(:ymd).first
          else
            @unsighn_team=Teamcore.find_by(access_token:session[:access_token] )
            @guest_user=@unsighn_team
            @workguest="ゲストログイン"     
            @schedules = Schedule.where("schedules.user_id=? and schedules.ymd > ?",@guest_user.user_id,Time.current.yesterday).reorder(:ymd).first        
          end
        end
      rescue LoadError
        render plain: "一度ブラウザを閉じて再度お試してください。"
      rescue => e
        p e
        p e.class # 例外の種類
        p e.message
        render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
      end 
    end

    def update_set_schedule
      begin
        @schedule = Schedule.find(params[:id])
      rescue LoadError
        render plain: "一度ブラウザを閉じて再度お試してください。"
      rescue ActiveRecord::RecordNotFound => e
        redirect_to new_schedule_path, notice: '先ほどアクセスしたページは存在しませんでした。'
      rescue => e
        p e
        p e.class # 例外の種類
        p e.message
        render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
      end
    end

    def team_name
      begin
        if @workguest.present?
            @team=Teamcore.find_by(access_token:session[:access_token] )
          else
            @team =Teamcore.find_by(user_id:current_user.id)
            if @team.nil?
              @team=0
            end
        end
       rescue LoadError
          render plain: "一度ブラウザを閉じて再度お試してください。"
       rescue => e
          p e
          p e.class # 例外の種類
          p e.message
          render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
       end
    end

    def set_token
      session[:access_token] = params[:access_token]
    end

    def token_check
      begin
        if Teamcore.find_by(access_token:session[:access_token] )
          session[:access_token] = params[:access_token]
        else
          #redirect_to root_path, notice: 'ログインが必要です' 
          render file:"errors/error_404_user"
        end
      rescue LoadError
        render plain: "一度ブラウザを閉じて再度お試してください。"
      end
    end

    def login_kaku
      begin
        if current_user.present?
          @token=Teamcore.find_by(user_id:current_user.id )
          return false
        else
          return true
        end
      rescue LoadError
        render plain: "一度ブラウザを閉じて再度お試してください。"
      end
    end
    

    # Only allow a list of trusted parameters through.
    def schedule_params
      params.require(:schedule).permit(:ymd, :start, :end, :place, :addcomment,:user_id,:teamcore_id)
    end
end
