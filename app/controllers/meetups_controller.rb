class MeetupsController < ApplicationController

  def index
    @meetup = Meetup.new
    @meetups = Meetup.all

    n = @meetups.count
  end

  def new
    if request.referrer.split("/").last == "meetups"
      flash[:notice] = nil
    end
    @meetup = Meetup.new
  end

  def edit
    @meetup = Meetup.find_by(id: params[:id])
  end

  def create
    @meetup = Meetup.new(meetup_params)
    if @meetup.save
      respond_to do |format|
        format.html { redirect_to @meetup }
        format.js
      end
    else
      respond_to do |format|
        flash[:notice] = {error: ["a meetup with this topic already exists"]}
        format.html { redirect_to new_meetup_path }
        format.js { render template: 'meetups/meetup_error.js.erb'} 
      end
    end
  end

  def update
    meetup = Meetup.find_by(id: params[:id])
    meetup.update(meetup_params)
    redirect_to meetup
  end

  def show
    @meetup = Meetup.find_by(id: params[:id])

    @Locations = []

    @message = Message.new
  end

  private

    def meetup_params
      params.require(:meetup).permit(:topic)
    end

end
