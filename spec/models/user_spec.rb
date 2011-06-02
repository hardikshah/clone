require 'spec_helper'

describe User do

  before(:each) do
    @attr = { 
      :first_name => "John", 
      :last_name => "Doe", 
      :email => "johndoe@example.com",
      :password => "foobar",
      :password_confirmation => "foobar" 
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a first name" do
    no_first_name_user = User.new(@attr.merge(:first_name => ""))
    no_first_name_user.should_not be_valid
  end

  it "should require a last name" do
    no_last_name_user = User.new(@attr.merge(:last_name => ""))
    no_last_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject first names that are too long" do
    long_first_name = "j" * 51
    long_first_name_user = User.new(@attr.merge(
                                    :first_name => long_first_name))
    long_first_name_user.should_not be_valid
  end
  
  it "should reject last names that are too long" do
    long_last_name = "j" * 51
    long_last_name_user = User.new(@attr.merge(
                                    :last_name => long_last_name))
    long_last_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com A_USER@FOO.ORG first.last@test.co.uk]
    addresses.each do |address|
      valid_email_user = User.create(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org test@fake.]
    addresses.each do |address|
      invalid_email_user = User.create(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject duplicate email addresses that are up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "activation status" do
    before(:each) do
      @user = User.new(@attr)
    end

    it "should have an active attribute" do
      @user.should respond_to(:active)
    end
    it "should be false on creation" do
      @user.active.should_not be_true
    end
    it "should have an activation_hash attribute" do
      @user.should respond_to(:activation_hash)
    end
    it "should have a populated activation hash" do
      @user.save
      @user.activation_hash.should_not be_nil
    end
    it "should be active when activated" do
      @user.save
      @user.activate!
      @user.active.should be_true
    end
    it "should have a blank activation_hash attribute when activated" do
      @user.save
      @user.activate!
      @user.activation_hash.should be_nil
    end
  end

  describe "password validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "")).
        should_not be_valid
    end
    
    it "should reject short password" do
      short = "j" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long password" do
      long = "j" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end   
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the password don't match" do
        @user.has_password?("invalid").should_not be_true
      end
    end
    
    describe "authentication method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "invalid")
        wrong_password_user.should be_nil
      end
      it "should return nil for an email address with no user" do
        wrong_email_user = User.authenticate("null@foo.com", @attr[:password])
        wrong_email_user.should be_nil
      end
      it "should return the user on email/password match" do
        valid_user = User.authenticate(@attr[:email],@attr[:password])
        valid_user.should == @user
      end
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
      @user.activate!
    end
    
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
  describe "post associations" do
    before(:each) do
      @user = User.create(@attr)
      @post1 = Factory(:post, :user => @user, :created_at => 1.day.ago)
      @post2 = Factory(:post, :user => @user, :created_at => 1.hour.ago)
    end
    it "should have a posts attribute" do
      @user.should respond_to(:posts)
    end
    it "should have the right posts in the right order" do
      @user.posts.should == [@post2, @post1]
    end
    it "should destroy associated posts" do
      @user.destroy
      [@post1, @post2].each do |post|
        Post.find_by_id(post.id).should be_nil
      end
    end
  end
  
  describe "trades associations" do
    before(:each) do
      @user = User.create(@attr)
      @user.activate!
      @other_user = Factory(:user, :email => "otheruser@example.com")
      @other_user.activate!
      @post = Factory(:post, :user => @other_user)
      @t1 = Factory(:trade, :user => @user, :post => @post, 
                    :created_at => 1.day.ago)
      @t2 = Factory(:trade, :user => @user, :post => @post, 
                    :created_at => 1.hour.ago)
    end
    it "should have a trades attribute" do
      @user.should respond_to(:trades)
    end
    it "should have the right trades in the right order" do
      @user.trades.should == [@t2, @t1]
    end
    it "should destroy associated trades" do
      @user.destroy
      [@t1, @t2].each do |trade|
        Trade.find_by_id(trade.id).should be_nil
      end
    end
  end
  
  describe "community relationships" do
    before(:each) do
      @user = User.create(@attr)
      @user.activate!
      @community = Factory(:community)
    end
    it "should have a communities relationship method" do
      @user.should respond_to(:community_relationships)
    end
    it "should have a communities method" do
      @user.should respond_to(:communities)
    end
    it "should respond to member_of_community? method" do
      @user.should respond_to(:member_of_community?)
    end
    it "should join_community! method" do
      @user.should respond_to(:join_community!)
    end
    it "should join a community" do
      @user.join_community!(@community)
      @user.should be_member_of_community(@community)
    end
    it "should include the community in the joined communities array" do
      @user.join_community!(@community)
      @user.communities.should include(@community)
    end
    it "should have a leave_community! method" do
      @user.should respond_to(:leave_community!)
    end
    it "should leave a community" do
      @user.join_community!(@community)
      @user.leave_community!(@community)
      @user.should_not be_member_of_community(@community)
    end
  end
end
