require 'Date'

class StaticPagesController < ApplicationController
  def home
    wday = Date.today.wday
    day = Date.today.day
    wdayDiff = wday - 1
    monday = Date.today - wdayDiff
    friday = monday + 4

    #Only include second month name if friday is in the next month.
    secondMonth = ''
    if (monday.month != friday.month)
      secondMonth = Date::MONTHNAMES[friday.month] + " "
    end

    @dateHeader = Date::MONTHNAMES[monday.month] + " " + monday.day.to_s + " - " + friday.day.to_s

    #Today's panel should show on initial load.
    @activePanel = Date.today.wday - 1
    if @activePanel < 0
      @activePanel = 0
    elsif @activePanel > 4
      @activePanel = 4
    end

    @theWeek ||= Array.new
    for i in 0..4
      allEpisodes = Episode.where("date = ?", monday + i).includes(:tv_show, :guest)

      #Group them by Tv Show.
      today = Hash.new
      allEpisodes.each do |episode|
        if today.has_key? episode.tv_show
          today[episode.tv_show].push(episode)
        else
          today.store(episode.tv_show, [ episode ])
        end
      end

      @theWeek.push(today)
    end
  end

  def about
  end
end
