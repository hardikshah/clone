require 'spec_helper'

describe State do
  before(:each) do
    @attr = { :name => "Georgia",
              :abbreviation => "GA"
      }
  end
  it "should create a new instance given valid attributes" do
    State.create!(@attr)
  end
  
  describe "city associations" do
    before(:each) do
      @state = State.create(@attr)
    end
    
    it "should have a cities attribute" do
      @state.should respond_to(:cities)
    end
  end
end
