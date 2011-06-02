require 'spec_helper'

describe "Communities" do
  describe "create" do
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
        it "should not create a community" do
          lambda do
            visit new_community_path
            fill_in :name,          :with => ""
            fill_in :description,   :with => ""
            click_button
            response.should render_template("communities/new")
            response.should have_selector("div#error_explanation")
          end.should_not change(Community, :count)
        end
      end
      
      describe "success" do
        it "should create a community" do
          lambda do
            visit new_community_path
            fill_in :name,          :with => "Test Community"
            fill_in :description,   :with => "Test Community Description"
            click_button
            response.should have_selector("div.flash.success",
                                    :content => "Community")
            response.should render_template("communities/show")
          end.should change(Community, :count).by(1)
        end
      end
    end
  end
end
