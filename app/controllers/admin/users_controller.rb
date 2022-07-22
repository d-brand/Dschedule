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
    @users.assign_attributes(user_params)
    if @users.save!
      redirect_to admin_users_path
     else
      render action: 'edit'
    end
  end

  def index
    @users = User.joins(:teamcore).where.not(id: current_user.id).order(created_at: :asc)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path
    else
      render new_admin_user_path
    end
  end

  def destroy
    @users.destroy
    redirect_to admin_users_path
  end
  
  private
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def find_user
      @users = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:id, :email, :password, :name, teamcore_attributes:[:teamname])
    end
  
end
