class RelationshipsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  def create
    @user = User.find_by_id(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html do 
        flash[:success] = "Following user"
        redirect_to @user
      end
      format.js
    end
    
  end
  
  def destroy
    @user = Relationship.find_by_id(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html do 
        flash[:success] = "User unfollowed"
        redirect_to @user
      end
      format.js
    end
  end
  
end