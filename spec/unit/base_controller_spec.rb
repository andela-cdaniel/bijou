require "spec_helper"

describe Bijou::BaseController do
  describe "#initialize" do
    it "Takes exactly one argument" do
      expect{ Bijou::BaseController.new }.to raise_error ArgumentError
      expect{ Bijou::BaseController.new("hello", "world") }.to raise_error ArgumentError
    end

    it "Returns a new instance of Bijou BaseController" do
      expect(Bijou::BaseController.new("")).to be_an_instance_of Bijou::BaseController
    end
  end

  describe "#params" do
    it "Returns a hash" do
      allow(ENV).to receive(:params).and_return({})
      expect(Bijou::BaseController.new(ENV).params).to be_an_instance_of Hash
    end
  end

  describe "#response" do
    it "Returns a new instance of Rack Response" do
      expect(Bijou::BaseController.new(ENV).response("")).to be_an_instance_of Rack::Response
    end
  end

  describe "#show_response" do
    context "When response hasn't been initialized" do
      it "Returns nil" do
        expect(Bijou::BaseController.new(ENV).show_response).to be nil
      end
    end

    context "When response has been initialized" do
      it "Returns a new instance of Rack Response" do
        base_controller = Bijou::BaseController.new(ENV)
        base_controller.response("")
        expect(base_controller.show_response).to be_an_instance_of Rack::Response
      end
    end
  end

  describe "#render" do
    it "Returns a new instance of Rack Response" do
      class Tilt::ErubisTemplate
        def initialize(arg)
          ""
        end

        def render &block
          ""
        end
      end
      allow(Object).to receive(:const_missing).and_return("")
      expect(Bijou::BaseController.new(ENV).render("")).to be_an_instance_of Rack::Response
    end
  end

  describe "#redirect_to" do
    it "Returns a new instance of Rack Response" do
      expect(Bijou::BaseController.new(ENV).redirect_to("/")).to be_an_instance_of Rack::Response
    end
  end

  describe "#render_template" do
    it "Calls Tilt ErubisTemplate and returns a result" do
      class Tilt::ErubisTemplate
        def initialize(arg)
          ""
        end

        def render &block
          ""
        end
      end
      allow(Object).to receive(:const_missing).and_return("")
      expect(Bijou::BaseController.new(ENV).render_template("body")).to eql("")
    end
  end

  describe "#controller" do
    it "Should be a private method" do
      expect{ Bijou::BaseController.new(ENV).controller_name }.to raise_error NoMethodError
    end

    it "Converts a camel cased string to snake case
        and replaces all instances of the word 'Controller'
        with an empty string" do
      class MySpecController < Bijou::BaseController; end
      expect(MySpecController.new(ENV).send(:controller)).to eql("my_spec")
    end
  end
end
