module ApplicationHelper
  
  def title
    @base_title = "Two Pickles"
    if @title.nil?
      @base_title
    else
      "#{@base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("tp_logo_hi_sm.jpg", :alt => "Two Pickles", :class => "round")
  end
end
