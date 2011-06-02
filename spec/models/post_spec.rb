require 'spec_helper'

describe Post do
  before(:each) do
    @user = Factory(:user)
    @user.activate!
    @attr = {
      :title => "Test Post Title",
      :description => "Test Post Description",
      :city_id => 1
    }
  end
  it "should create a new instance given for registered post" do
    @user.posts.create!(@attr)
  end
  it "should create a new instance for a non-registered post" do
    email = Factory.next(:email)
    Post.create!(@attr.merge({ :email => email }))
  end
  describe "active status" do
    it "should be false for a non-registered post" do
      email = Factory.next(:email)
      post = Post.create!(@attr.merge({ :email => email }))
      post.active.should_not be_true
    end
    it "should be true for a registered post" do
      post = @user.posts.create!(@attr)
      post.active.should be_true
    end
  end
  describe "hash activation" do
    describe "for registered posts" do
      it "should be blank" do
        post = @user.posts.create!(@attr)
        post.activation_hash.should be_nil
      end    
    end
    describe "for non-registered posts" do
      before(:each) do
        @email = Factory.next(:email)
        @post = Post.new(@attr.merge({ :email => @email }))
      end
      it "should be populated for a nonregistered post" do
        @post.save
        @post.activation_hash.should_not be_nil
      end
      it "should be active when activated" do
        @post.save
        @post.activate!
        @post.active.should be_true
      end
    end
  end
  describe "user associations" do
    before(:each) do
      @post = @user.posts.create!(@attr)
    end
    it "should have a user attribute" do
      @post.should respond_to(:user)
    end
    it "should have the right associated user" do
      @post.user_id.should == @user.id
      @post.user.should == @user
    end
  end
  describe "nonregistered user associations" do
    it "should allow for creating with only an email address" do
      Post.create!(@attr.merge({ :email => "test@test.com" }))
    end
  end 
  describe "city associations" do
    before(:each) do
      @post = @user.posts.create!(@attr)
    end
    it "should have a city attribute" do
      @post.should respond_to(:city)
    end
  end
  describe "trade associations" do
    before(:each) do
      @post = @user.posts.create!(@attr)
      @other_user = Factory(:user, :email => "test@example.com")
      @other_user.activate!
      
      @t1 = Factory(:trade, :user => @user, :post => @post,
                    :created_at => 1.day.ago)
      @t2 = Factory(:trade, :user => @other_user, :post => @post,
                    :created_at => 1.hour.ago)
    end
    it "should have a trades attribute" do
      @post.should respond_to(:trades)
    end
    it "should destroy associated trades" do
      @post.destroy
      [@t1, @t2].each do |trade|
        Trade.find_by_id(trade.id).should be_nil
      end
    end
  end
  describe "validations" do
    it "should require either a user id or email address" do
      post = Post.create(@attr)
      post.should_not be_valid
    end
    it "should require a nonblank title" do
      @user.posts.build(@attr.merge({ :title => " " })).should_not be_valid
    end
    it "should reject a long title" do
      @user.posts.build(@attr.merge({ 
                          :title => "j"*101 })).should_not be_valid
    end
    it "should require a nonblank description" do
      @user.posts.build(@attr.merge( {
                        :description => " " })).should_not be_valid
    end
    it "should reject a long description" do
      @user.posts.build(@attr.merge({ 
                        :description => "j"*256 })).should_not be_valid
    end
    it "should reject a long trade for" do
      @user.posts.build(@attr.merge({ 
                        :trade_for => "j"*256 })).should_not be_valid
    end
    it "should require a city" do
      @user.posts.build(@attr.merge({ :city_id => nil })).should_not be_valid
    end
    it "should reject invalid email addresses"
    it "should reject identical user email addresses"
    it "should reject identical user email addresses up to case"
  end
end
