class DashboardController < ApplicationController
  def index
    if not current_user
      redirect_to root_url
    end
  end
end