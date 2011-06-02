require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Two Pickles"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get :home
      response.should be_success
    end
    
    it "should have the right title" do
      get :home
      response.should have_selector("title",
                          :content => @base_title + " | Home")
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get :contact
      response.should be_success
    end
    
    it "should have the right title" do
      get :contact
      response.should have_selector("title",
                          :content => @base_title + " | Contact Us")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get :about
      response.should be_success
    end
    
    it "should have the right title" do
      get :about
      response.should have_selector("title",
                          :content => @base_title + " | About")
    end
    
    it "should have some correct page content" do
      get :about
      response.should have_selector("h1", 
                          :content => "What is Two Pickles?")
    end
  end

  describe "GET 'privacy'" do
    it "should be successful" do
      get :privacy
      response.should be_success
    end
    
    it "should have the right title" do
      get :privacy
      response.should have_selector("title",
                          :content => @base_title + " | Privacy")
    end
    
    it "should have some correct page content" do
      get :privacy
      response.should have_selector("h1",
                          :content => "Privacy Policy")
    end
  end

  describe "GET 'terms'" do
    it "should be successful" do
      get :terms
      response.should be_success
    end
    
    it "should have the right title" do
      get :terms
      response.should have_selector("title",
                          :content => @base_title + " | Terms of Use")
    end
    
    it "should have some correct page content" do
      get :terms
      response.should have_selector("h1",
                          :content => "TWOPICKLES.ORG TERMS OF USE")
    end
  end

  describe "GET 'faq'" do
    it "should be successful" do
      get :faq
      response.should be_success
    end
    
    it "should have the right title" do
      get :faq
      response.should have_selector("title",
                          :content => @base_title + " | FAQ")
    end
    
    it "should have some correct page content" do
      get :faq
      response.should have_selector("h1",
                          :content => "Frequenty Asked Questions")
    end
    
  end

  describe "GET 'userguide'" do
    it "should be successful" do
      get :userguide
      response.should be_success
    end
    
    it "should have the right title" do
      get :userguide
      response.should have_selector("title",
                          :content => @base_title + " | User Guide")
    end
    
    it "should have some correct page content" do
      get :userguide
      response.should have_selector("h1",
                          :content => "How to Use Two Pickles Communities")
    end
  end

  describe "GET 'safety'" do
    it "should be successful" do
      get :safety
      response.should be_success
    end
    
    it "should have the right title" do
      get :safety
      response.should have_selector("title",
                          :content => @base_title + " | Safety Tips")
    end
    it "should have some correct page content" do
      get :safety
      response.should have_selector("h1",
                          :content => "Safety Tips")
    end
  end
end
