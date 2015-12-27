require "spec_helper"

describe Bijou::Response do
  describe "#initialize" do
    context "When called with valid arguments" do
      it "Returns a new rack response instance" do
        expect(Bijou::Response.new("Hello", 200, {}).reply).to be_an_instance_of Rack::Response
      end
    end

    context "When called with invalid arguments" do
      it "Raises an error if called with less than two elements" do
        expect{ Bijou::Response.new }.to raise_error ArgumentError
      end

      it "Raises an error when an invalid argument is passed in" do
        expect{ Bijou::Response.new(400, 500) }.to raise_error TypeError
      end
    end
  end
end
