require 'rss'

class Admin::ShowsController < ApplicationController
  def index
  end

  def loadRss
    data = open('http://www.interbridge.com/xml/lineupsdate.xml').read
    #data = File.open('app/assets/rss.txt', 'r') { |f| f.read }
    rss = nil

    begin
      rss = RSS::Parser.parse(data)
    rescue
      begin
        rss = RSS::Parser.parse(data)
      rescue
      end
    end

    unless rss.nil?
      #Process the HTML blocks for each day to pull out the shows and guests.
      #Unfortunately they are not well formed HTML, so we need to do ugly parsing with strings.
      #TODO - Learn more about blocks to see how they could be used here.
      #TODO - Move all of this login into Models somewhere.

      rss.items.each do |item|
        dateString = item.guid.to_s.split(/-/).first.split(/>/).last
        itemDate = Date.strptime(dateString, "%m/%d/%y")

        description = item.description
        description["<p>"] = ""
        description["</p>"] = ""

        shows = description.strip.split(/<br>/)

        shows.each do |show|
          show["<b>"] = ""
          showIdentifier = show.split(/<\/b>:/).first.strip.downcase

          tvShow = TvShow.find_by_identifier(showIdentifier)
          if tvShow.nil?
            tvShow = TvShow.new(name: showIdentifier, identifier: showIdentifier)
            tvShow.save()
          end

          guests = show.split(/<\/b>:/).second.split(/, /)

          guests.each do |guestName|
            if guestName.include? 'href'
              guestName = guestName.split(/>/).second.split(/</).first
            end
            guestName = guestName.split(/\(R/).first
            guestName = guestName.strip

            guest = Guest.find_by_name(guestName)
            if guest.nil?
              guest = Guest.new(name: guestName)
              guest.save()
            end

            #TODO - Handle the case where a previously assigned guest for an episode is no longer appearing.
            episode = Episode.find_by_date_and_tv_show_id_and_guest_id(itemDate, tvShow.id, guest.id)
            if episode.nil?
              episode = Episode.new(date: itemDate, tv_show_id: tvShow.id, guest_id: guest.id)
              episode.save()
            end
          end
        end
      end
    end
  end
end
