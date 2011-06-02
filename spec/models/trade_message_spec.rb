require 'spec_helper'

describe TradeMessage do
  
  before(:each) do
    @user = Factory(:user)
    @user.activate!
    @post = Factory(:post, :user => @user)
    @trading_user = Factory(:user, :email => "otheruser@example.com")
    @trading_user.activate!
    @trade = Factory(:trade, :post => @post, :user => @trading_user)
    
    @attr = {
      :message => "Trade message",
      :from_trader => true
    }
  end
  
  it "should create a new instance with valid attributes" do
    @trade.trade_messages.create!(@attr)
  end
  
  describe "trade associations" do
    before(:each) do
      @trade_message = @trade.trade_messages.create(@attr)
    end
    
    it "should have a trade attribute" do
      @trade_message.should respond_to(:trade)
    end
    
    it "should have the right trade attribute" do
      @trade_message.trade_id.should == @trade.id
      @trade_message.trade.should == @trade
    end

  end

  describe "validations" do
    it "should require a nonblank message" do
      @trade.trade_messages.build(@attr.merge({ 
                                  :message => " " })).should_not be_valid
    end
    it "should reject a long message" do
      @trade.trade_messages.build(@attr.merge({ 
                                  :message => "j"*256 })).should_not be_valid
    end
  end

end
