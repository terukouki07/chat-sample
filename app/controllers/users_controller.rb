class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @post_images = @user.post_images 
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update
    redirect_to _path
  end

  private
  # ストロングパラメータ
  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end
end
