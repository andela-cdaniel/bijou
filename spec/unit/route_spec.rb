require "spec_helper"

describe Bijou::Route do
  describe "#initialize" do
    it "Takes exactly one argument" do
      expect{ Bijou::Route.new }.to raise_error ArgumentError
      expect{ Bijou::Route.new([], []) }.to raise_error ArgumentError
    end

    it "Returns a new instance of Bijou Route" do
      expect(
        Bijou::Route.new(
          ["/", {:controller=>"pages", :action=>"index"}]
        )
      ).to be_an_instance_of Bijou::Route
    end
  end

  describe "#controller" do
    subject(:bijou_route) do
      Bijou::Route.new(["/", {:controller=>"pages", :action=>"index"}])
    end

    it "Creates a controller based on the route array" do
      expect(bijou_route.controller).to eql("PagesController")
    end
  end
end
