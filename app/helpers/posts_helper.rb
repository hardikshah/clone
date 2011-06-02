module PostsHelper
  
  def current_user_is_owner?(post)
    current_user?(post.user)
  end
  
  def current_user_has_trade_with_post?(post)
    post.traders.include?(current_user)
  end
end
