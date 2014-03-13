require 'spec_helper'
require_relative '../lib/listener_tracker'

describe ListenerTracker do
  context "when empty" do
    it "add listeners to total" do
      expect { subject.post_listeners(['0.0.0.0', '5.5.5.5']) }.to change{ subject.unique_listeners }.from(0).to(2)
    end
  end
end
