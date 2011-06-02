class TradesController < ApplicationController

  def index
    @user_id = params[:user_id] || nil
    if @user_id.nil?
      redirect_to root_path
    else
      @user = User.find(@user_id)
      @title = "All My Trades"
      @trades = @user.trades.active.paginate(:page => params[:page])
    end
  end

  def create
    @post = Post.find_by_id(params[:post_id])
    @trade = @post.trades.build(params[:trade])
    if signed_in?
      @trade.user = current_user
      @trade.email = nil
      if @trade.save
        flash[:success] = "Trade created!"
        redirect_to post_path(@post)
      else
        # TODO: show errors
        render :action => "posts/show"
      end
    else
      if @trade.save
        flash[:success] = "Thanks for creating your trade! " +
                          "Confirm your trade "+
                          "using the instructions provided in the email "+
                          "we just sent you!"
        redirect_to post_path(@post)
      else
        # TODO: show errors

      end
    end
  end

  def activate
    # TODO fill this out
  end

  def destroy
    Trade.find(params[:id]).destroy
    redirect_back_or root_path
  end

  def show
    @trade = Trade.find(params[:id])
    @post = @trade.post
    @title = @post.title
  end

end