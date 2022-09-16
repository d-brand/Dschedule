class Admin::UsersController < ApplicationController
    before_action :admin_user
    before_action :find_user, only: [:edit, :update, :destroy]
 
  def index
    @users = User.joins(:teamcore).where.not(id: current_user.id).order(created_at: :asc)
   # @team = Teamcores.all
  end
  
  def edit
  end

  def new
    @user=User.new
    @user.build_teamcore
  end


  def update
    @team = @user.teamcore
   begin
    if @user.update!(user_params)
      redirect_to admin_users_path
     else
      render action: 'edit'
    end
  rescue
    @errors = @user.errors
    @clone_user = @user.dup
    @clone_user.assign_attributes(user_params)
    @user.skip_confirmation!
    @clone_user.save
    render action: :edit
  end
  end

  def index
    @users = User.joins(:teamcore).where.not(id: current_user.id).order(created_at: :asc)
  end

  def create
    @user = User.new(user_params)
    @user.skip_confirmation!
    if @user.save
      redirect_to admin_users_path
    else
      render new_admin_user_path
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path
  end
  
  private
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:id, :email, :password, :password_confirmation, :name, teamcore_attributes:[:id, :teamname])
    end
  
  
end
