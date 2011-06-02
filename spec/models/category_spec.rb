require 'spec_helper'

describe Category do

  before(:each) do
    @attr = { 
      :name => "Test Category", 
      :description => "This is a test category",
      :category_type => "Goods"
    }
  end
  
  it "should create a new instance given valid attributes" do
    Category.create!(@attr)
  end
  
  describe "validations" do    
    it "should require a name" do
      @category = Category.new(@attr.merge({ :name => "" }))
      @category.should_not be_valid
    end
    
    it "should require a description" do
      @category = Category.new(@attr.merge({ :description => "" }))
      @category.should_not be_valid
    end
    
    it "should require a type" do
      @category = Category.new(@attr.merge({ :category_type => "" }))
      @category.should_not be_valid
    end
    
    it "should require a valid type" do
      @category = Category.new(@attr.merge({ :category_type => "Invalid" }))
      @category.should_not be_valid
    end
    
    it "should reject long names" do
      @category = Category.new(@attr.merge({ :name => "j"*51 }))
      @category.should_not be_valid
    end
    
    it "should reject long descriptions" do
      @category = Category.new(@attr.merge({ :description => "j"*101 }))
    end
    
    it "should reject duplicate categories" do
      @category = Category.create!(@attr)
      @dup_category = Category.new(@attr)
      @dup_category.should_not be_valid
    end
  end
  
  describe "post relationships" do
    before(:each) do
      @category = Factory(:category)
    end
    it "should have a posts method" do
      @category.should respond_to(:posts)
    end
  end
  
end
