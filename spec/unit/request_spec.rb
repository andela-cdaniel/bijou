require "spec_helper"

describe Bijou::Request do
  describe "#initialize" do
    it "Expects one argument to be passed in" do
      expect{ Bijou::Request.new }.to raise_error ArgumentError
    end

    it "Returns a new Rack Request instance when an argument is passed in" do
      expect(Bijou::Request.new(ENV).vars).to be_an_instance_of Rack::Request
    end
  end
end
