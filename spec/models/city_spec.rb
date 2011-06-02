require 'spec_helper'

describe City do
  before(:each) do
    @state = Factory(:state)
    @attr = { :name => "Atlanta",
              :state_id => 1 
      }
  end
  it "should create a new instance given valid attributes" do
    @state.cities.create!(@attr)
  end
  
  describe "state associations" do
    before(:each) do
      @city = @state.cities.create(@attr)
    end
    it "should have a state attribute" do
      @city.should respond_to(:state)
    end
    it "should have the right associated state" do
      @city.state_id.should == @state.id
      @city.state.should == @state
    end
  end
  
end
