class UserCommunityRelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @community = 
        Community.find(params[:user_community_relationship][:community_id])
    current_user.join_community!(@community)
    flash[:success] = "Joined community!"
    redirect_to @community
  end
  
  def destroy
    @community = UserCommunityRelationship.find(params[:id]).community
    current_user.leave_community!(@community)
    flash[:success] = "Left community!"
    redirect_to @community
  end
end
