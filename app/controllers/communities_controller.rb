class CommunitiesController < ApplicationController
  before_filter :admin_user,      :only => [:destroy, :activate]
  before_filter :authenticate,    :only => [:create, :new, :destroy]
  
  def index
    @user_id = params[:user_id] || nil
    if @user_id.nil?
      @title = "All Communities"
      @communities = Community.active.paginate(:page => params[:page])
    else
      @user = User.find(@user_id)
      @title = "All My Communities"
      @communities = @user.communities.active.paginate(:page => params[:page])
    end
  end
  
  def new
    @title = "Create New Community"
    @community = Community.new
    1.times { @community.community_images.build }
  end
  
  def create
    if signed_in?
      @community = Community.new(params[:community])
      if @community.save
        flash[:success] = "Community created!"
        redirect_to community_path(@community)
      else
        @title = "Create New Community"        
        1.times { @community.community_images.build }
        render 'new'
      end
    else
      redirect_to root_path
    end
  end
  
  def activate
    @community = Community.find_by_id(params[:id])
    if @community.nil?
      flash[:error] = "Invalid activation."
      redirect_to root_path
    else
      @community.activate!
      flash[:success] = "The community has been activated!"
      redirect_to @community
    end
  end
  
  def show
    @community = Community.find(params[:id])
    @title = @community.name
  end
  
  def destroy
    @community = Community.find(params[:id])
    @community.destroy
    redirect_to communities_path
  end

  private
  
    def admin_user
      deny_access unless admin_user?
    end

end
