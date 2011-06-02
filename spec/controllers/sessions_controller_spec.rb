require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end
  end
  
  describe "POST 'create'" do
    
    describe "invalid sign in" do
      
      before(:each) do
        @attr = { :email => "jsnickerson@gmail.com", :password => "foobar" }
      end
    
      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end
    
      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Sign in")
      end
    
      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    describe "valid sign in" do
      
      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end
      
      describe "if user is not activated" do
      
        it "should not be signed in" do
          post :create, :session => @attr
          controller.current_user.should_not == @user
          controller.should_not be_signed_in
        end
        it "should redirect to the signin page" do
          post :create, :session => @attr
          response.should render_template('new')
        end
        it "should have a flash.now message" do
          post :create, :session => @attr
          flash.now[:error].should =~ /must be activated/i
        end
      end
      
      describe "if user is activated" do
        before(:each) do
          @user.activate!
        end
        it "should sign the user in" do
          post :create, :session => @attr
          controller.current_user.should == @user
          controller.should be_signed_in
        end
        it "should redirect to the user show page" do
          post :create, :session => @attr
          response.should redirect_to(user_path(@user))
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    it "should sign a user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end

end
