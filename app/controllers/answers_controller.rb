class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :token_check,if: :login_kaku
  before_action :team_name


  # GET /answers
  # GET /answers.json
  def index
    begin
      redirect_to '/schedules'
      @answers = Answer.all
    rescue LoadError
      render plain:"一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
    @answers = Answer.all
  end

  # POST /answers
  # POST /answers.json
  def create
    begin
      @answer = Answer.new(answer_params)
      respond_to do |format|
        if @answer.save
          format.html { redirect_to schedule_path(id:@answer.schedule_id, access_token: params[:access_token],teamcores_teamname: @team.teamname),notice: '出欠を登録しました。' }
          format.json { render :show, status: :created, location: @answer }
        else
          format.html { redirect_to schedule_path(id:@answer.schedule_id, access_token: params[:access_token],teamcores_teamname: @team.teamname), notice: '名前が記入されていません。' }
          format.json { render json: @answer.errors, status: :unprocessable_entity }
        end
      end
    rescue LoadError
      render plain:"一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    begin
      respond_to do |format|
        if @answer.update(answer_params)
          format.html { redirect_to @answer, notice: '出欠を更新しました。' }
          format.json { render :show, status: :ok, location: @answer }
        else
          format.html { render :edit }
          format.json { render json: @answer.errors, status: :unprocessable_entity }
        end
      end
    rescue LoadError
      render plain:"一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    begin
      @answer.destroy
      respond_to do |format|
        if current_user.present?
          format.html { redirect_to schedule_path(id:@answer.schedule_id,teamcores_teamname: @team.teamname), notice: '登録が削除されました。' }
        else
          format.html { redirect_to schedule_path(id:@answer.schedule_id, access_token: params[:access_token],teamcores_teamname: @team.teamname),notice: '登録が削除されました。' }
        end
        format.json { head :no_content }
      end
    rescue LoadError
      render plain:"一度ブラウザを閉じて再度お試してください。"
    rescue => e
      p e
      p e.class # 例外の種類
      p e.message
      render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      begin
        @answer = Answer.find(params[:id])

      rescue LoadError
        p "一度ブラウザを閉じて再度お試してください。"
      rescue => e
        p e
        p e.class # 例外の種類
        p e.message
        p  plain:"システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
      end
    end

    def token_check
      begin
        if Teamcore.find_by(access_token:session[:access_token] )
          session[:access_token] = params[:access_token]
        else
          redirect_to root_path, notice: 'ログインが必要です' 
        end
      rescue LoadError
        render plain:"一度ブラウザを閉じて再度お試してください。"
      rescue => e
        p e
        p e.class # 例外の種類
        p e.message
        render plain: "システム管理者にお手数ですが発生した内容をご連絡ください。(連絡先:info＠d-brand.jp)"
      end
    end

    def team_name
      begin
        if current_user.nil?
          @workguest='ゲストログイン'
        end
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


    def login_kaku
      unless current_user
        true
      else
        false
      end
    end

    # Only allow a list of trusted parameters through.
    def answer_params
      params.require(:answer).permit(:schedule_id, :name, :reason, :comment)
    end
end