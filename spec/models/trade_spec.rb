require 'spec_helper'

describe Trade do

  before(:each) do
    @user = Factory(:user)
    @user.activate!
    @other_user = Factory(:user, :email => "otheruser@sample.com")
    @other_user.activate!
    
    @post = Factory(:post, :user => @other_user)
    @attr = { :content => "Trade proposal content"}
  end

  it "should create a new instance given valid attributes" do
    @user.trades.create!(@attr)
  end

  describe "user associations" do
    
    before(:each) do
      @trade = @user.trades.create(@attr)
    end
    
    it "should have a user attribute" do
      @trade.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @trade.user_id.should == @user.id
      @trade.user.should == @user
    end
  end
  
  describe "post associations" do
    before(:each) do
      @trade = Factory(:trade, :user => @user, :post => @post)
    end
    it "should have a post attribute" do
      @trade.should respond_to(:post)
    end
    it "should have the right associated post" do
      @trade.post_id.should == @post.id
      @trade.post.should == @post
    end
  end
  
  describe "trade message associations" do
    before(:each) do
      @trade = Factory(:trade, :user => @user, :post => @post)
      @tm1 = Factory(:trade_message, :trade => @trade, 
                      :created_at => 1.day.ago)
      @tm2 = Factory(:trade_message, :trade => @trade, 
                      :created_at => 1.hour.ago)
    end
    it "should have a trade messages attribute" do
      @trade.should respond_to(:trade_messages)
    end
    it "should have trade messages in the right order" do
      @trade.trade_messages.should == [@tm2, @tm1]
    end
    it "should delete trade messages" do
      @trade.destroy
      [@tm1, @tm2].each do |trade_message| 
        TradeMessage.find_by_id(trade_message.id).should be_nil
      end
    end
  end
  
  describe "validations" do
    it "should require either a user id or email address" do
      trade = @post.trades.create(@attr)
      trade.should_not be_valid
    end

    it "should require nonblank content" do
      @user.trades.build(@attr.merge({ :content => " " })).should_not be_valid
    end
    it "should reject long content" do
      @user.trades.build(@attr.merge({ 
                          :content => "j"*256 })).should_not be_valid
    end
    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org test@fake.]
      addresses.each do |address|
        invalid_email_trade = Trade.create(@attr.merge(:email => address))
        invalid_email_trade.should_not be_valid
      end
    end
  end

  describe "active status" do
    it "should be false for a non-registered trader" do
      # non-registered trader
      email = Factory.next(:email)
      trade = @post.trades.create!(@attr.merge({ :email => email }))
      trade.active.should_not be_true
    end
    it "should be true for a registered trader" do
      email = Factory.next(:email)
      trade = @post.trades.build(@attr)
      trade.user_id = @user.id
      trade.save

      trade.active.should be_true
    end

  end

  describe "traders associations" do
    before(:each) do
      @third_user = Factory(:user, :email => "otheruser2@sample.com")
      @third_user.activate!

      @trade = Factory(:trade, :user => @user, :post => @post)
      @trade2 = Factory(:trade, :user => @third_user, :post => @post)
    end
    
    it "should be associated to both users" do
      @post.traders.should == [@user, @third_user]
    end
  end
  
  describe "user trade_posts associations" do
    before(:each) do
      @post2 = Factory(:post, :user => @other_user)
      @trade = Factory(:trade, :user => @user, :post => @post)
      @trade2 = Factory(:trade, :user => @user, :post => @post2)
    end
    
    it "should be associated to both posts" do
      @user.trade_posts.should == [@post2, @post]
    end
  end


end
