require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do
    describe "for non admin users" do
      it "should redirect to root path" do
        get :index
        response.should redirect_to(signin_path)
      end
    end
    describe "for admin users" do
      before(:each) do
        @user = Factory(:user)
        @user.activate!
        @user.toggle!(:admin)
        test_sign_in(@user)
        second = Factory( :user, :first_name => "Jim",
                          :last_name => "Thompson",
                          :email => "jim@twopickles.com")
        third = Factory(  :user, :first_name => "Steve",
                          :last_name => "Harrison",
                          :email => "steve@twopickles.com")
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end
      it "should be successful" do
        get :index
        response.should be_success
      end
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All Users")
      end
      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.first_name)
        end
      end
      it "should paginate user" do
       get :index
       response.should have_selector("div.pagination")
       response.should have_selector("span.disabled", :content => "Previous")
       response.should have_selector("a",   :href => "/users?page=2",
                                            :content => "2")
       response.should have_selector("a",   :href => "/users?page=2", 
                                            :content => "Next")
      end
    end
    
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have the right title" do
      get :new
      response.should have_selector("title",
                        :content => "Register")
    end
    it "should have a first name field" do
      get :new
      response.should have_selector("input[name='user[first_name]']"+
                                      "[type='text']")
    end
    it "should have a last name field" do
      get :new
      response.should have_selector("input[name='user[last_name]']"+
                                    "[type='text']")
    end
    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]']"+
                                    "[type='text']")
    end
    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]']"+
                                    "[type='password']")
    end
    it "should have a password confirmation field" do
      get :new
      response.should have_selector("input"+
                                    "[name='user[password_confirmation]']"+
                                    "[type='password']")
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
      @user.activate!
      test_sign_in(@user)
    end
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    it "should show the user's posts" do
      p1 = Factory(:post, :user => @user, :title => "Test Post 1")
      p2 = Factory(:post, :user => @user, :title => "Test Post 2")
      get :show, :id => @user
      response.should have_selector("div.title", :content => p1.title)
      response.should have_selector("div.title", :content => p2.title)
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      
      before(:each) do
        @attr = { :first_name => "", 
                  :last_name => "", 
                  :email => "", 
                  :password => "", 
                  :password_confirmation => ""
        }
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Register")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      
    end
    
    describe "success" do
      before(:each) do
        @attr = { :first_name             => "John",
                  :last_name              => "Nickerson", 
                  :email                  => "jsnickerson@gmail.com",
                  :password               => "foobar",
                  :password_confirmation  => "foobar"
        }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      it "should redirect to the confirmation screen" do
        post :create, :user => @attr
        response.should redirect_to(root_path)
      end
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /thanks for signing up/i
      end
      it "should have the correct activation status (false)" do
        post :create, :user => @attr
        assigns(:user).active.should_not be_true
      end
    end
  end
  
  describe "GET 'activate'" do
    describe "failure" do
      before(:each) do
        @id = ""
        @activation_hash = ""
      end
      it "should redirect to the home page" do
        get :activate, :id => @id, :activation_hash => @activation_hash
        response.should redirect_to(root_path)
      end
      it "should have an error message" do
        get :activate, :id => @id, :activation_hash => @activation_hash
        flash[:error].should =~ /invalid activation/i
      end
    end
    describe "success" do
      before(:each) do
        @user = Factory(:user)
        @user.save
      end
      it "should sign the user in" do
        get :activate,  :id => @user.id,
                        :activation_hash => @user.activation_hash
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      it "should redirect to the users page" do
        get :activate,  :id => @user.id, 
                        :activation_hash => @user.activation_hash
        response.should redirect_to(user_path(@user))
      end
      it "should have an activation confirmation message" do
        get :activate,  :id => @user.id,
                          :activation_hash => @user.activation_hash
        flash[:success].should =~ /account has been activated/i
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      @user.activate!
      test_sign_in(@user)
    end
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit profile")
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      @user.activate!
      test_sign_in(@user)
    end
    describe "failure" do
      before(:each) do
        @attr = { :first_name => "", :last_name => "", 
                  :email => "", :password => "",
                  :password_confirmation => "" }
      end
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit profile")
      end
    end
    describe "success" do
      before(:each) do
        @attr = { :first_name => "Johnny", :last_name => "Appleseed",
                  :email => "jappleseed@gmail.com",
                  :password => "barbaz", :password_confirmation => "barbaz" }
      end
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.first_name.should == @attr[:first_name]
        @user.last_name.should == @attr[:last_name]
        @user.email.should == @attr[:email]
      end
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
      @user.activate!
    end
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    describe "as an admin user" do
      before(:each) do
        @admin_user = Factory(:user, :email => "admin@twopickles.com",
                                    :admin => true)
        @admin_user.activate!
        test_sign_in(@admin_user)
      end
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      it "should redirect to the users path" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
      it "should not be able to delete themself" do
        lambda do
          delete :destroy, :id => @admin_user
        end.should_not change(User, :count)
      end
    end
  end

  describe "authentication of show/edit/update pages" do
    before(:each) do
      @user = Factory(:user)
      @user.activate!
    end
    describe "for non-signed-in users" do
      it "should deny access to 'show'" do
        get :show, :id => @user
        response.should redirect_to(signin_path)
      end
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end
    describe "for signed-in non-admin users" do
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        wrong_user.activate!
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'show'" do
        get :show, :id => @user
        response.should redirect_to(root_path)
      end
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
    describe "for signed-in admin users" do
      before(:each) do
        admin_user = Factory(:user, :email => "user@example.net")
        admin_user.activate!
        admin_user.toggle!(:admin)
        test_sign_in(admin_user)
      end
      it "should give access to 'show'" do
        get :show, :id => @user
        response.should render_template('show')
      end
      it "should give access to 'edit'" do
        get :edit, :id => @user
        response.should render_template('edit')
      end
      it "should have a 'delete' link on the 'edit' page" do
        get :edit, :id => @user
        response.should have_selector("a", 
                                  :content => "Delete user")
      end
      it "should give access to 'update'" do
        @attr = { :first_name => "Johnny", :last_name => "Appleseed",
                  :email => "jappleseed@gmail.com",
                  :password => "barbaz", :password_confirmation => "barbaz" 
                }
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.first_name.should == @attr[:first_name]
        @user.last_name.should == @attr[:last_name]
        @user.email.should == @attr[:email]
      end
    end
  end
end
