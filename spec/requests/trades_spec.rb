require 'spec_helper'

describe "Trades" do
  
  describe "create" do
    
    describe "as a nonregistered user" do
    
      describe "failure" do
        it "should not create a trade"
      end      
      describe "success" do
        it "should create a new trade"
      end
    end

    describe "as a registered user" do
      describe "failure" do
        it "should not create a trade"
      end
      describe "success" do
        it "should create a trade"
      end
      
    end
  end
end
