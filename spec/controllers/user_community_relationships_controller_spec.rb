require 'spec_helper'

describe UserCommunityRelationshipsController do

  describe "access control" do
    
    it "should require signin for create" do
      post :create
      response.should redirect_to(signin_path)
    end
    
    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
    
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @community = Factory(:community)
    end
    
    it "should create a user community relationship" do
      lambda do
        post  :create, 
              :user_community_relationship => { :community_id => @community }
        response.should be_redirect
      end.should change(UserCommunityRelationship, :count).by(1)
    end
    
  end
  
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @community = Factory(:community)
      @user.join_community!(@community)
      @relationship = 
              @user.community_relationships.find_by_community_id(@community)
    end
    
    it "should destroy a relationship" do
      lambda do
        delete :destroy, :id => @relationship
        response.should be_redirect
      end.should change(UserCommunityRelationship, :count).by(-1)
    end
    
  end
end
