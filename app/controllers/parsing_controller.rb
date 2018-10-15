class ParsingController < ApplicationController
  require 'open-uri'
  require 'nokogiri'
  require 'openssl'

  def index	

  end

  def arrivals
    begin
      # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
      doc = Nokogiri::HTML open("https://www.cph.dk/en/flight-information/arrivals")
      css = doc.css('div.flights__table div.stylish-table__row  div.stylish-table__cell')

      @arrivals = []
      @arrival_hash = {} 

      css.each_with_index do |title, index|
        if index > 7 
          @arrival_hash["Tid"] = title.text.strip if index%8 == 0
          @arrival_hash["Expected"] =  title.text.strip if (index-1)%8 == 0
          @arrival_hash["Airline"] =  title.text.strip if (index-2)%8 == 0
          @arrival_hash["Arriving from"] =  title.text.strip if (index-3)%8 == 0
          @arrival_hash["Gate"] =  title.text.strip if (index-4)%8 == 0
          @arrival_hash["Terminal"] =  title.text.strip if (index-5)%8 == 0
          @arrival_hash["Status"] =  title.text.strip if (index-6)%8 == 0
          @arrival_hash["Updates"] =  title.text.strip if (index-7)%8 == 0
          @arrivals.push(@arrival_hash) if (index-7)%8 == 0
          @arrival_hash = {}  if (index-7)%8 == 0       
        end
      end
     render :json => {:arrivals => @arrivals}

    rescue => e
      puts e # Error message
      puts e.io.status # Http Error code
      puts e.io.readlines # Http response body
    end

  end

  def departures
    begin
      # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
      doc = Nokogiri::HTML open("https://www.cph.dk/en/flight-information/departures")
      css = doc.css('div.flights__table div.stylish-table__row  div.stylish-table__cell')

      @departures = []
      @departure_hash = {} 

      css.each_with_index do |title, index|
        if index > 7 
          @departure_hash["Tid"] = title.text.strip if index%8 == 0
          @departure_hash["Expected"] =  title.text.strip if (index-1)%8 == 0
          @departure_hash["Airline"] =  title.text.strip if (index-2)%8 == 0
          @departure_hash["Destination"] =  title.text.strip if (index-3)%8 == 0
          @departure_hash["Gate"] =  title.text.strip if (index-4)%8 == 0
          @departure_hash["Terminal"] =  title.text.strip if (index-5)%8 == 0
          @departure_hash["Status"] =  title.text.strip if (index-6)%8 == 0
          @departure_hash["Updates"] =  title.text.strip if (index-7)%8 == 0
          @departures.push(@departure_hash) if (index-7)%8 == 0
          @departure_hash = {}  if (index-7)%8 == 0       
        end
      end

      render :json => {:departures => @departures}

    rescue => e
      puts e # Error message
      puts e.io.status # Http Error code
      puts e.io.readlines # Http response body
    end


  end

end
