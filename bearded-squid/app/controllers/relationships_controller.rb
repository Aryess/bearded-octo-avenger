class RelationshipsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  def create
    @user = User.find_by_id(params[:relationship][:followed_id])
    if @user != current_user
      current_user.follow!(@user)
      flash[:success] = "Following user"
    end
    redirect_to @user
  end
  
  def destroy
    @user = Relationship.find_by_id(params[:id]).followed
    current_user.unfollow!(@user)
    flash[:success] = "User unfollowed"
    redirect_to @user
  end
  
end