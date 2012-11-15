class TvShowsController < ApplicationController
  # GET /tv_shows
  # GET /tv_shows.json
  def index
    @tv_shows = TvShow.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tv_shows }
    end
  end

  # GET /tv_shows/1
  # GET /tv_shows/1.json
  def show
    @tv_show = TvShow.find(params[:id])

    wday = Date.today.wday
    day = Date.today.day
    wdayDiff = wday - 1
    monday = Date.today - wdayDiff
    friday = monday + 4

    @theWeek ||= Array.new
    for i in 0..4
      allEpisodes = Episode.where("date = ? AND tv_show_id = ?", monday + i, @tv_show.id).includes(:guest)

      #Group them by Date.
      theWeek = Hash.new
      allEpisodes.each do |episode|
        if theWeek.has_key? episode.date
          theWeek[episode.date].push(episode)
        else
          theWeek.store(episode.date, [ episode ])
        end
      end

      @theWeek.push(theWeek)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tv_show }
    end
  end

  # GET /tv_shows/new
  # GET /tv_shows/new.json
  def new
    @tv_show = TvShow.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tv_show }
    end
  end

  # GET /tv_shows/1/edit
  def edit
    @tv_show = TvShow.find(params[:id])
  end

  # POST /tv_shows
  # POST /tv_shows.json
  def create
    @tv_show = TvShow.new(params[:tv_show])

    respond_to do |format|
      if @tv_show.save
        format.html { redirect_to @tv_show, notice: 'Tv show was successfully created.' }
        format.json { render json: @tv_show, status: :created, location: @tv_show }
      else
        format.html { render action: "new" }
        format.json { render json: @tv_show.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tv_shows/1
  # PUT /tv_shows/1.json
  def update
    @tv_show = TvShow.find(params[:id])

    respond_to do |format|
      if @tv_show.update_attributes(params[:tv_show])
        format.html { redirect_to @tv_show, notice: 'Tv show was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tv_show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tv_shows/1
  # DELETE /tv_shows/1.json
  def destroy
    @tv_show = TvShow.find(params[:id])
    @tv_show.destroy

    respond_to do |format|
      format.html { redirect_to tv_shows_url }
      format.json { head :no_content }
    end
  end
end
