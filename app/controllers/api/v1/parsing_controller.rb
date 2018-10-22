class Api::V1::ParsingController < ApplicationController
  require 'open-uri'
  require 'nokogiri'
  require 'openssl'

  def arrivals
    begin
      # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
      doc = Nokogiri::HTML open(arrivals__url)
      css = doc.css('div.flights__table div.stylish-table__row  div.stylish-table__cell')
      tags = ["Tid", "Expected", "Airline", "Arriving from", "Gate", "Terminal", "Status", "Updates"]

      i = 0
      @arrivals = []
      @arrival_hash = {}
      
      css.each_with_index do |title, index|
        if index > 7
          @arrival_hash[tags[i]] = title.text.strip if (index - i)%8 == 0

          if (index-7)%8 == 0
            @arrivals.push(@arrival_hash)
            @arrival_hash = {}
            i = 0
          else
            i += 1
          end
        end
      end

      render :json => { arrivals: @arrivals }

    rescue => e
      puts e.to_s # Error message
      # puts e.io.status # Http Error code
      # puts e.io.readlines # Http response body
      render :json => { arrivals: [], error: e.to_s }
    end
  end

  def arrivals__url
    date = params[:date].split('-')[0]+" - "+ params[:date].split('-')[1]+" - "+params[:date].split('-')[2]
    return "https://www.cph.dk/en/flight-information/arrivals?q="+params[:q]+"&date="+date+"&time="+params[:time]+""
  end

  def departures
    begin
      # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
      doc = Nokogiri::HTML open(departures__url)
      css = doc.css('div.flights__table div.stylish-table__row  div.stylish-table__cell')
      tags = ["Tid", "Expected", "Airline", "Destination", "Gate", "Terminal", "Status", "Updates"]

      i = 0
      @departures = []
      @departure_hash = {}

      css.each_with_index do |title, index|
        if index > 7
          @departure_hash[tags[i]] = title.text.strip if (index - i)%8 == 0

          if (index-7)%8 == 0
            @departures.push(@departure_hash)
            @departure_hash = {}
            i = 0
          else
            i += 1
          end
        end
      end

      @departures = @departures.select{|k| k["Airline"] == params[:q]} if params[:q].present?
      @departures = @departures.select{|k| k["Tid"] >= params[:t]} if params[:t].present? 
      render :json => { departures: @departures }

    rescue => e
      puts e.to_s # Error message
      # puts e.io.status # Http Error code
      # puts e.io.readlines # Http response body
      render :json => { departures: [], error: e.to_s }
    end
  end

  def departures__url
    date = params[:date].split('-')[0]+" - "+ params[:date].split('-')[1]+" - "+params[:date].split('-')[2]
    return "https://www.cph.dk/en/flight-information/departures?q="+params[:q]+"&date="+date+"&time="+params[:time]
  end

end
