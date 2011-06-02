class PagesController < ApplicationController
  def home
    @title = "Home"
  end

  def contact
    @title = "Contact Us"
  end

  def about
    @title = "About"
  end

  def privacy
    @title = "Privacy Policy"
  end

  def terms
    @title = "Terms of Use"
  end

  def faq
    @title = "FAQ"
  end

  def userguide
    @title = "User Guide"
  end

  def safety
    @title = "Safety Tips"
  end

end
