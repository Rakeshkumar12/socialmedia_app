class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:index, :following, :followers]
  before_action :currect_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

 def index
    @users = User.paginate(page: params[:page], :per_page => 10)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], :per_page =>10 )
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page], :per_page => 10)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], :per_page => 10)
    render 'show_follow'
  end

  private

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def currect_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end
