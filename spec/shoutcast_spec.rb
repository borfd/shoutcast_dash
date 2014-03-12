require 'spec_helper'
require_relative "../lib/shoutcast"

describe Shoutcast do
  it "returns the listeners" do
    VCR.use_cassette('shoutcast') do
      expect(Shoutcast.new.listener_count).to eq(4)
    end
  end
end
