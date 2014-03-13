require 'spec_helper'
require_relative "../lib/listener_tracker"

describe ListenerTracker do
  context "when empty" do
    it "adds listeners to total" do
      expect { subject.post_listeners(['0.0.0.0', '5.5.5.5']) }.to change{ subject.unique_listeners }.from(0).to(2)
    end
  end
  context "with elements in it" do
    before do
      subject.post_listeners(["test"])
    end
    it "doesn't increment for existing listener" do
      expect { subject.post_listeners(["test", "new_listener"]) }.to change{ subject.unique_listeners }.from(1).to(2)
    end
  end
end
