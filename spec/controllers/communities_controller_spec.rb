require 'spec_helper'

describe CommunitiesController do
  render_views

  describe "access control" do

    before(:each) do
      @community = Factory(:community)
      @community.activate!
    end
    
    describe "for non-admin users" do
      it "should deny access to 'destroy'" do
        delete :destroy, :id => @community
        response.should redirect_to(signin_path)
      end
      it "should deny access to 'activate'" do
        get :activate, :id => @community
        response.should redirect_to(signin_path)
      end
    end
  end

  describe "GET 'new'" do
    describe "for non-registered user" do
      it "should not be successful" do
        get :new
        response.should redirect_to(signin_path)
      end
    end
    describe "for registered user" do
      before(:each) do
        @user = Factory(:user)
        @user.activate!
        test_sign_in(@user)
      end
      it "should be successful" do
        get :new
        response.should be_success
      end
      
      it "should have the right title" do
        get :new
        response.should have_selector("title", 
                                :content => "Create New Community")
      end

      it "should have a name field" do
        get :new
        response.should have_selector("input[name='community[name]']"+
                                      "[type='text']")
      end
      
      it "should have a description field" do
        get :new
        response.should have_selector("textarea[name="+
                                      "'community[description]']")
      end
    end
  end  
  
  describe "GET 'activate'" do

    describe "for invalid community" do
      before(:each) do
        @user = Factory(:user, :admin => true)
        @user.activate!
        test_sign_in(@user)
        @id = ""
      end

      it "should redirect to the homepage" do
        get :activate, :id => @id
        response.should redirect_to(root_path)
      end
      it "should have an error message" do
        get :activate, :id => @id
        flash[:error].should =~ /invalid/i
      end
    end

    describe "for a non-signed-in user" do
      it "should redirect to the sign-in page" do
        get :activate, :id => @id
        response.should redirect_to(signin_path)
      end
    end
    describe "for an unauthorized user" do
      before(:each) do
        @user = Factory(:user)
        @user.activate!
      end
      it "should redirect to the homepage" do
        get :activate, :id => @id
        response.should redirect_to(signin_path)
      end
    end
    describe "success" do
      before(:each) do
        @user = Factory(:user, :admin => true)
        @user.activate!
        test_sign_in(@user)        
        @community = Factory(:community)
        @id = @community.id
      end
      it "should redirect to the community page" do
        get :activate, :id => @id
        response.should redirect_to(community_path(@community))
      end
      it "should have an activation confirmation message" do
        get :activate, :id => @id
        flash[:success].should =~ /community has been activated/i
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
          @attrs = {
            :name => "Test Community",
            :description => "Test Community Description"
          }
        end
        describe "for missing name" do
          it "should not create a community" do
            lambda do
              post :create, :community => @attrs.merge({ :name => "" })
            end.should_not change(Community, :count)
          end
          it "should have the right title" do
            post :create, :community => @attrs.merge({ :name => "" })
            response.should have_selector("title", 
                                        :content => "Create New Community")
          end
          it "should render the new community page" do
            post :create, :community => @attrs.merge({ :name => "" })
            response.should render_template('new')
          end
        end
        describe "for missing description" do
          it "should not create a post" do
            lambda do
              post :create, :community => @attrs.merge({ :description => "" })
            end.should_not change(Community, :count)
          end
          it "should have the right title" do
            post :create, :community => @attrs.merge({ :description => "" })
            response.should have_selector("title", 
                                        :content => "Create New Community")
          end
          it "should render the new community page" do
            post :create, :community => @attrs.merge({ :description => "" })
            response.should render_template('new')
          end
        end
      end
      describe "success" do
        before(:each) do
          @attrs = {
            :name => "Test Community",
            :description => "Test Community Description"
          }
        end
        it "should create a community" do
          lambda do
            post :create, :community => @attrs
          end.should change(Community, :count).by(1)
        end
        it "should redirect to the community page" do
          post :create, :community => @attrs
          response.should redirect_to(community_path(assigns(:community)))
        end
        it "should have a flash message" do
          post :create, :community => @attrs
          flash[:success].should =~ /community created/i
        end
        it "should have the correct active status (false)" do
          post :create, :community => @attrs
          assigns(:community).active.should_not be_true
        end
      end
    end
    describe "for non-signed-in users" do
      before(:each) do
        @attrs = {
          :name => "Test Community",
          :description => "Test Community Description"
        }
      end
      describe "failure" do
        it "should not create a community" do
          lambda do
            post :create, :community => @attrs
          end.should_not change(Community, :count)
        end
        it "should render the signin page" do
          post :create, :community => @attrs
          response.should redirect_to(signin_path)
        end
      end
    end
  end
  describe "DELETE 'destroy'" do
    before(:each) do
      @community = Factory(:community)
      @community.activate!
    end
    describe "for a non-authorized user" do
      it "should deny access" do
        delete :destroy, :id => @community
        response.should redirect_to(signin_path)
      end
    end
    describe "for an authorized user" do
      before(:each) do
        @user = Factory(:user, :admin => true)
        @user.activate!
        test_sign_in(@user)
      end
      it "should destroy the post" do
        lambda do
          delete :destroy, :id => @community
        end.should change(Community, :count).by(-1)
      end
    end
  end
end