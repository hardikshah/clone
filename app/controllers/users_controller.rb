class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:index, :show, :edit, :update]
  before_filter :correct_user, :only => [:show, :edit, :update]
  before_filter :admin_user,   :only => [:index, :destroy]
  
  
  def index 
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
  end
  
  def new
    @title = "Register"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Thanks for signing up! Confirm your account "+
                        "using the instructions provided in the email "+
                        "we just sent you!"
                        
      redirect_to root_path
    else
      @title = "Register"
      @user.password = nil
      @user.password_confirmation = nil
      
      render 'new'
    end
  end
  
  def show
    # user is pulled from correct_user
    @posts = @user.posts.paginate(:page => params[:page])
    @title = "#{@user.first_name} #{@user.last_name}"
  end

  def activate
    @user = User.find_by_id(params[:id])
    if @user.nil?
      flash[:error] = "Invalid activation."
      redirect_to root_path
    elsif @user.activation_hash == params[:activation_hash]
      @user.activate!
      flash[:success] = "Your account has been activated!"
      sign_in @user
      redirect_to @user
    else
      flash[:error] = "Incorrect activation hash!"
      redirect_to root_path
    end
  end
  
  def edit
    # user is pulled from correct_user    
    @title = "Edit profile"
  end
  
  def update
    # user is pulled from correct_user    
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit profile"
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if current_user == @user
      flash[:error] = "Can't delete yourself"
      redirect_to users_path
    else
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_path
    end
  end
    
  
  private 
      
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) or admin_user?
    end
    
    def admin_user
      deny_access unless admin_user?
    end
    
end
