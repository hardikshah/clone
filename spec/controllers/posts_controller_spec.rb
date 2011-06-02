require 'spec_helper'

describe PostsController do
  render_views

  describe "access control" do
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Create Post")
    end
    it "should have a title field" do
      get :new
      response.should have_selector("input[name='post[title]']"+
                                      "[type='text']")
    end
    it "should have a description field" do
      get :new
      response.should have_selector("textarea[name='post[description]']")
    end
    it "should have a trade for field" do
      get :new
      response.should have_selector("input[name='post[trade_for]']"+
                                      "[type='text']")
    end
    it "should have a state field" do
      get :new
      response.should have_selector("select", :name => "state_id")
    end
    it "should have category fields" 
    describe "for a signed-in user" do
      before(:each) do
        @user = Factory.create(:user)
        @user.activate!
        test_sign_in(@user)
      end
      it "should not have an email address field" do
        get :new
        response.should_not have_selector("input[name='post[email]']"+
                                          "[type='text']")
      end
    end
    describe "for a non-signed-in user" do
      it "should have an email address field" do
        get :new
        response.should have_selector("input[name='post[email]']"+
                                      "[type='text']")
      end
    end
  end  
  
  describe "GET 'show'" do
    it "should have test cases"
  end
  
  describe "GET 'edit'" do
    it "should have test cases"
  end
  
  describe "PUT 'update'" do
    it "should have test cases"
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
        @post = Factory(:post)
        @post.save
      end
      it "should redirect to the post page" do
        get :activate,  :id => @post.id, 
                        :activation_hash => @post.activation_hash
        response.should redirect_to(post_path(@post))
      end
      it "should have an activation confirmation message" do
        get :activate,  :id => @post.id,
                          :activation_hash => @post.activation_hash
        flash[:success].should =~ /post has been activated/i
      end
    end
  end  
  describe "POST 'create'" do
    describe "for signed-in users" do
      before(:each) do
        @user = Factory(:user)
        @user.activate!
        test_sign_in(@user)
      end

      describe "failure" do
        before(:each) do
          @attr = { :title => "Test",
                    :description => "Test",
                    :city_id => 1 }
        end

        describe "for missing title" do
          it "should not create a post" do
            lambda do
              post :create, :post => @attr.merge({ :title => "" })
            end.should_not change(Post, :count)
          end
          it "should render the new post page" do
            post :create, :post => @attr.merge({ :title => "" })
            response.should render_template('new')
          end          
        end
        describe "for missing description" do
          it "should not create a post" do
            lambda do
              post :create, :post => @attr.merge({ :description => "" })
            end.should_not change(Post, :count)
          end
          it "should render the new post page" do
            post :create, :post => @attr.merge({ :description => "" })
            response.should render_template('new')
          end          
        end
        describe "for missing city" do
          it "should not create a post" do
            lambda do
              post :create, :post => @attr.merge({ :city_id => "" })
            end.should_not change(Post, :count)
          end
          it "should render the home page" do
            post :create, :post => @attr.merge({ :city_id => "" })
            response.should render_template('new')
          end          
        end
      end

      describe "success" do
        before(:each) do
          @attr = { :title => "Lorem ipsum",
                    :description => "Lorem ipsum",
                    :city_id => 1}
        end
        it "should create a post" do
          lambda do
            post :create, :post => @attr
          end.should change(Post, :count).by(1)
        end
        it "should redirect to the home page" do
          post :create, :post => @attr
          response.should redirect_to(post_path(assigns(:post)))
        end
        it "should have a flash message do" do
          post :create, :post => @attr
          flash[:success].should =~ /post created/i
        end
        it "should have the correct active status (true) " do
          post :create, :post => @attr
          assigns(:post).active.should be_true
        end
      end      
    end
    describe "for non-signed-in users" do
      describe "failure" do
        before(:each) do
          @attr = { :title => "" }
        end

        it "should not create a post" do
          lambda do
            post :create, :post => @attr
          end.should_not change(Post, :count)
        end
        it "should render the home page" do
          post :create, :post => @attr
          response.should render_template('new')
        end
      end

      describe "success" do
        before(:each) do
          @attr = { :title => "Lorem ipsum",
                    :description => "Lorem ipsum",
                    :email => "user@example.com",
                    :city_id => 1}
        end
        it "should create a post" do
          lambda do
            post :create, :post => @attr
          end.should change(Post, :count).by(1)
        end
        it "should redirect to the confirmation screen" do
          post :create, :post => @attr
          response.should redirect_to(root_path)
        end
        it "should have a welcome message" do
          post :create, :post => @attr
          flash[:success].should =~ /thanks for creating your post/i
        end
        it "should have the correct active status (false)" do
          post :create, :post => @attr
          assigns(:post).active.should_not be_true
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    describe "for a non-authorized user" do
      before(:each) do
        @user = Factory(:user)
        @user.activate!
        wrong_user = Factory(:user, :email => Factory.next(:email))
        wrong_user.activate!
        test_sign_in(wrong_user)
        @post = Factory(:post, :user => @user)
      end
      it "should deny access" do
        delete :destroy, :id => @post
        response.should redirect_to(root_path)
      end
    end
    describe "for an authorized user" do
      before(:each) do
        @user = Factory(:user)
        @user.activate!
        test_sign_in(@user)
        @post = Factory(:post, :user => @user)
      end
      it "should destroy the post" do
        lambda do
          delete :destroy, :id => @post
        end.should change(Post, :count).by(-1)
      end
    end
    describe "for a non-signed-in but authorized user" do
      before(:each) do
        @post = Factory(:post, :email => Factory.next(:email))
      end
      it "should destroy the post"
    end
    describe "for a non-signed-in and unauthorized user" do
      before(:each) do
        @post = Factory(:post, :email => Factory.next(:email))
        @post.activate!
      end
      it "should deny access" do
        delete :destroy, :id => @post
        response.should redirect_to(signin_path)
      end
      it "should not destroy the post" do
        lambda do
          delete :destroy, :id => @post
        end.should_not change(Post, :count)
      end
    end
  end
end