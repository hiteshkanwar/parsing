require "rails_helper"

RSpec.describe "Parsing", :type => :request do

  it "data from cph.dk for arrivals" do
    post "/api/v1/arrivals", :params => { date: Date.today.to_s, time: "03", q: "" }
    JSON.parse(response.body)["arrivals"].count >0
  end

  it "data from cph.dk for departures" do
    post "/api/v1/departures", :params => { date: "24-10-2018", time: "03", q: "" }
    JSON.parse(response.body)['departures'].count >0
  end
end