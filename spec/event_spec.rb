require 'google_client'

describe GoogleClient::Event do
  describe "when initializing object" do
    it "should return an Event instance" do
      GoogleClient::Event.new.should be_instance_of GoogleClient::Event
    end
    it "should accept a block to initialize the object" do
      e = GoogleClient::Event.new do |event|
        event.title = "Foo"
        event.description = "Bar"
        event.location = "Barcelona"
      end

      e.title.should eql("Foo")
      e.description.should eql("Bar")
      e.location.should eql("Barcelona")
    end
  end
end