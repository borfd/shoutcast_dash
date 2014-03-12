require 'spec_helper'
require_relative "../lib/shoutcast"

describe Shoutcast do

  it "can read the SHOUTCAST_PASSWORD environment variable" do
    expect(ENV["SHOUTCAST_PASSWORD"]).to_not be_empty
  end

  it "returns the listeners" do
    VCR.use_cassette('shoutcast') do
      expect(Shoutcast.new.listener_count).to eq(11)
    end
  end


  it "returns user agents" do
    VCR.use_cassette('shoutcast') do
      expect(Shoutcast.new.user_agents.join).to include("Mozilla")
    end
  end

  it "returns now playing" do

    VCR.use_cassette('shoutcast', :record => :new_episodes) do

      expect(Shoutcast.new.now_playing).to eq('NeuralNET - The Darkside Deep Bass 2012 18-01-13')
    end
  end
end
