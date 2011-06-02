class StatesController < ApplicationController
  
  def index
    @states = State.find(:all)
    respond_to do |format|
      format.xml { render :xml => @states.to_xml(:include => :cities) }
    end
  end
  
  def show
    @state = State.find(params[:id])
    respond_to do |format|
      format.xml { render :xml => @state.to_xml(:include => :cities) }
    end
  end
end