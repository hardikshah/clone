require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector("title", :content => "Home")
  end
    
  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector("title", :content => "About")
  end
  
  it "should have a User Guide page at '/userguide'" do
    get '/userguide'
    response.should have_selector("title", :content => "User Guide")
  end
  
  it "should have an FAQ page at '/faq'" do
    get '/faq'
    response.should have_selector("title", :content => "FAQ")
  end
  
  it "should have a Safety Tips page at '/safety'" do
    get '/safety'
    response.should have_selector("title", :content => "Safety Tips")
  end
  
  it "should have a Privacy Policy page at '/privacy'" do
    get '/privacy'
    response.should have_selector("title", :content => "Privacy Policy")
  end
  
  it "should have a Terms of Use page at '/terms'" do
    get '/terms'
    response.should have_selector("title", :content => "Terms of Use")
  end

  it "should have a signup page at '/register'" do
    get '/register'
    response.should have_selector("title", :content => "Register")
  end
  
  it "should have a contact page at '/contact'" do
    get '/contact'
    response.should have_selector("title", :content => "Contact")
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Register"
    response.should have_selector("title", :content => "Register")
    click_link "About"
    response.should have_selector("title", :content => "About")
    click_link "User Guide"
    response.should have_selector("title", :content => "User Guide")
    click_link "FAQ"
    response.should have_selector("title", :content => "FAQ")
    click_link "Safety Tips"
    response.should have_selector("title", :content => "Safety Tips")
    click_link "Privacy Policy"
    response.should have_selector("title", :content => "Privacy Policy")
    click_link "Terms of Use"
    response.should have_selector("title", :content => "Terms of Use")
  end
  
  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,  
                                          :content => "Sign in")
    end
    
    it "should not have a signout link" do
      visit root_path
      response.should_not have_selector("a", :href => signout_path,
                                          :content => "Sign out")
    end
    
    it "should not have a communities link" do
      visit root_path
      response.should_not have_selector("a", :href => communities_path,
                                          :content => "Communities")
    end
    
    it "should not have a profile link" do
      visit root_path
      response.should_not have_selector("a", :content => "Profile")
    end
    
    it "should not have a my account link" do
      visit root_path
      response.should_not have_selector("a", :content => "My Account")
    end
    
    it "should not have a communities link" do
      visit root_path
      response.should_not have_selector("a",  :href => communities_path,
                                          :content => "Communities")
    end
      
  end
  
  describe "when signed in" do
    describe "as a non-admin user" do
      before(:each) do
        @user = Factory(:user)
        @user.activate!
        visit signin_path
        fill_in :email,       :with => @user.email
        fill_in :password,    :with => @user.password
        click_button
      end

      it "should have a signout link" do
        visit root_path
        response.should have_selector("a",  :href => signout_path,
                                            :content => "Sign out")
      end
      it "should have a profile link" do
        visit root_path
        response.should have_selector("a",  :href => user_path(@user),
                                            :content => "Profile")
      end
      it "should have a my account link" do
        visit root_path
        response.should have_selector("a",  :href => '#',
                                            :content => "My Account")
      end
      it "should have a communities link" do
        visit root_path
        response.should have_selector("a",  :href => communities_path,
                                            :content => "Communities")
      end
      
    end
    describe "as an admin user" do
      before(:each) do
        @user = Factory(:user)
        @user.activate!
        @user.toggle!(:admin)
        visit signin_path
        fill_in :email,     :with => @user.email
        fill_in :password,  :with => @user.password
        click_button
      end
      it "should have an 'All users' link" do
        visit root_path
        response.should have_selector("a",  :href => users_path,
                                            :content => "All Users")
      end
    end
  end
end
