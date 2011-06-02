require 'spec_helper'

describe "Posts" do
  
  describe "create" do
    
    describe "as a nonregistered user" do
    
      describe "failure" do
        it "should not create a post" do
          lambda do
            visit new_post_path
            fill_in "Title",          :with => ""
            fill_in "Description",    :with => ""
            fill_in "Trade For",      :with => ""
            fill_in "Email Address",  :with => ""
            fill_in "City",           :with => ""
            click_button
            response.should render_template('posts/new')
            response.should have_selector("div#error_explanation")
          end.should_not change(Post, :count)
        end
      end      
      describe "success" do
        it "should create a new post" do
          lambda do
            visit new_post_path
            fill_in "Title",          :with => "Example Post"
            fill_in "Description",    :with => "Example Description"
            fill_in "Trade For",      :with => "Example Trade"
            fill_in "Email Address",  :with => "example@sample.com"
            fill_in "City",           :with => "1"
            click_button
            response.should have_selector("div.flash.success", 
                                            :content => "Thanks for creating")
            response.should render_template('pages/home')
          end.should change(Post, :count).by(1)
        end
      end

    end

    describe "as a registered user" do
      before(:each) do
        @user = Factory(:user)
        @user.activate!
        visit signin_path
        fill_in :email,       :with => @user.email
        fill_in :password,    :with => @user.password
        click_button
      end
      describe "failure" do
        it "should not create a post" do
          lambda do
            visit new_post_path
            fill_in "Title",          :with => ""
            fill_in "Description",    :with => ""
            fill_in "Trade For",      :with => ""
            fill_in "City",           :with => ""
            click_button
            response.should render_template('posts/new')
            response.should have_selector("div#error_explanation")
          end.should_not change(Post, :count)
        end
      end
      describe "success" do
        it "should create a post" do
          lambda do
            visit new_post_path
            fill_in "Title",          :with => "Test Post"
            fill_in "Description",    :with => "Test Description"
            fill_in "Trade For",      :with => "Test Trade"
            fill_in "City",           :with => "1"
            click_button
            response.should render_template('posts/show')
            response.should have_selector("div.flash.success", 
                                            :content => "Post created!")
          end.should change(Post, :count).by(1)
        end
        
      end
      
    end
    
  end
  
  describe "update" do
    describe "as another user (not post owner)" do
      it "should have test cases"
    end
    describe "as the post owner" do
      it "should have test cases"
    end
  end

end
