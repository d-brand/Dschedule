class HomeController < ApplicationController
    before_action :authenticate_user!
    before_action :teamname
    def index
    end

    def top
        if user_signed_in?
          #session[:filter_tags] = nil
          redirect_to schedules_path
        else
          redirect_to root_path
        end 
    end
  private

    def teamname
      if user_signed_in?
        @team =Teamcore.find_by(user_id:current_user.id)
      end
    end

end