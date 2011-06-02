class PostsController < ApplicationController
  before_filter :authenticate, :only => [:destroy, :edit, :update]
  before_filter :authorized_user, :only => [:destroy, :edit, :update]
  
  def index
    @user_id = params[:user_id] || nil
    if @user_id.nil?
      @title = "All Posts"
      @posts = Post.active.paginate(:page => params[:page])
    else
      @user = User.find(@user_id)
      @title = "All My Posts"
      @posts = @user.posts.active.paginate(:page => params[:page])
    end
  end
  
  def new
    @title = "Create Post"
    @post = Post.new
    @states = State.all
    @cities = City.all
    @goods = Category.find_all_by_category_type("Goods")
    @services = Category.find_all_by_category_type("Services")
    2.times { @post.post_images.build }
  end

  def create
    if signed_in?
      @post = current_user.posts.build(params[:post])
      if @post.save
        flash[:success] = "Post created!"
        redirect_to post_path(@post)
      else
        @states = State.all
        @cities = City.all
        @goods = Category.find_all_by_category_type("Goods")
        @services = Category.find_all_by_category_type("Services")
        2.times { @post.post_images.build }
        render 'new'
      end
    else
      @post = Post.new(params[:post])
      if @post.save
        flash[:success] = "Thanks for creating your post! " +
                          "Confirm your post "+
                          "using the instructions provided in the email "+
                          "we just sent you!"
        redirect_to root_path
      else
        @states = State.all
        @cities = City.all
        @goods = Category.find_all_by_category_type("Goods")
        @services = Category.find_all_by_category_type("Services")
        2.times { @post.post_images.build }
        
        render 'new'
      end
    end
  end
  
  def activate
    @post = Post.find_by_id(params[:id])
    if @post.nil?
      flash[:error] = "Invalid activation."
      redirect_to root_path
    elsif @post.activation_hash == params[:activation_hash]
      @post.activate!
      flash[:success] = "Your post has been activated!"
      redirect_to @post
    else
      flash[:error] = "Incorrect activation hash!"
      redirect_to root_path
    end
  end
  
  def destroy
    @post.destroy
    redirect_back_or root_path
  end
  
  def show
    @post = Post.find(params[:id])
    @title = @post.title
    @trade = Trade.new
    @trades = @post.trades
  end
  
  def edit
    @post = Post.find(params[:id])
    @states = State.all
    @cities = City.all
    @goods = Category.find_all_by_category_type("Goods")
    @services = Category.find_all_by_category_type("Services")
  end

  def update
    params[:post][:category_ids] ||= []
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post was successfully updated"
      redirect_to @post
    else
      @states = State.all
      @cities = City.all
      @goods = Category.find_all_by_category_type("Goods")
      @services = Category.find_all_by_category_type("Services")
      render 'edit'
    end
  end
  
  def search
    @inputs = params[:post]
    if @inputs.nil?
      @title = "Post Search"
      @query = nil
      @posts = Post.search(@query)
    else
      @title = "Post Search"
      @query = @inputs["query"]
      @posts = Post.search(@query)
    end
  end
    
  private
  
    def authorized_user
      @post = Post.find(params[:id])
      redirect_to root_path unless current_user?(@post.user)
    end
  
end