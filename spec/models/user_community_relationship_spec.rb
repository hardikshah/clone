require 'spec_helper'

describe UserCommunityRelationship do

  before(:each) do
    @user = Factory(:user)
    @community = Factory(:community)
    
    @relationship = @user.community_relationships.build(
                                        :community_id => @community.id)
  end
  
  it "should create a new instance given valid attributes" do
    @relationship.save!
  end
  
  describe "join methods" do
    
    before(:each) do
      @relationship.save
    end

    it "should have a user attribute" do
      @relationship.should respond_to(:user)
    end
    
    it "should have the right user" do
      @relationship.user.should == @user
    end
    
    it "should have a community attribute" do
      @relationship.should respond_to(:community)
    end
    
    it "shuld have the right joined community" do
      @relationship.community.should == @community
    end
    
  end

  describe "validations" do
        
    it "should require a user_id" do
      @relationship.user_id = nil
      @relationship.should_not be_valid
    end
    
    it "should require a community_id" do
      @relationship.community_id = nil
      @relationship.should_not be_valid
    end
    
  end
end
