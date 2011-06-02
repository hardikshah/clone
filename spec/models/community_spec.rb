require 'spec_helper'

describe Community do
  before(:each) do
    @attr = {
      :name => "Test Community",
      :description => "Test Description",
      :city => 1
    }
  end
  
  it "should create a new instance given valid attributes" do
    Community.create!(@attr)
  end
  
  describe "active status" do
    it "should be false when first created" do
      @community = Community.create!(@attr)
      @community.active.should be_false
    end
    
    it "should be true after activation" do
      @community = Community.create!(@attr)
      @community.activate!
      @community.active.should be_true
    end
  end
  
  describe "associations" do
    before(:each) do
      @community = Community.create!(@attr)
    end
    
    it "should have a users method" do
      @community.should respond_to(:users)
    end    
  end
  
  describe "validations" do
    it "should require a name" do
      Community.new(@attr.merge({ :name => " " })).should_not be_valid
    end
    
    it "should require a nonblank description" do
      Community.new(@attr.merge({ :description => " " })).should_not be_valid
    end
    
    it "should reject long names" do
      @long_name = "j" * 256
      Community.new(@attr.merge({ :name => @long_name })).should_not be_valid
    end
    
    it "should reject long descriptions" do
      @long_desc = "j" * 256
      Community.new(@attr.merge({ 
                        :description => @long_desc })).should_not be_valid
                                                        
    end
  end
end
