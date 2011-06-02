require 'spec_helper'

describe "Users" do
  describe "register" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit register_path
          fill_in "First Name",         :with => ""
          fill_in "Last Name",          :with => ""
          fill_in "Email",              :with => ""
          fill_in "Password",           :with => ""
          fill_in "Confirmation",       :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end  
    end
    describe "success" do
      it "should make a new user" do
        lambda do
          visit register_path
          fill_in "First Name",         :with => "John"
          fill_in "Last Name",          :with => "Nickerson"
          fill_in "Email",              :with => "jsnickerson@gmail.com"
          fill_in "Password",           :with => "foobar"
          fill_in "Confirmation",       :with => "foobar"
          click_button
          response.should render_template('pages/home')
        end.should change(User, :count).by(1)
      end
    end
  end
  
  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :email,       :with => ""
        fill_in :password,    :with => ""
        click_button
        response.should have_selector("div.flash.error",
                                        :content => "Invalid")
      end
    end
    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        user.activate!
        visit signin_path
        fill_in :email,       :with => user.email
        fill_in :password,    :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end

  describe "edit profile" do
    before(:each) do
      @user = Factory(:user)
      @user.activate!
      visit signin_path
      fill_in :email,       :with => @user.email
      fill_in :password,    :with => @user.password
      click_button
    end
    describe "failure" do
      it "should not change the users information"
    end
    describe "success" do
      it "should change the users information"
    end
  end
end
