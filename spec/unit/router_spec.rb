require "spec_helper"

describe Bijou::Router do
  describe "#initialize" do
    it "Returns a new instance of Bijou Router" do
      expect(Bijou::Router.new).to be_an_instance_of Bijou::Router
      expect(Bijou::Router.new.instance_variable_get("@app_routes")).to eql({})
    end
  end

  describe "#draw" do
    it "Doesn't take any arguments" do
      expect{ Bijou::Router.new.draw(25) }.to raise_error ArgumentError
    end

    it "Expects a block and executes the content of the passed in block" do
      result = Bijou::Router.new.draw do
        2 + 2
      end
      expect(result).to be 4
    end
  end

  describe "#root" do
    it "Takes exactly one argument" do
      expect{ Bijou::Router.new.root }.to raise_error ArgumentError
      expect{ Bijou::Router.new.root("hello", "world") }.to raise_error ArgumentError
    end

    it "Returns an array when a valid argument is passed in" do
      expect(Bijou::Router.new.root("pages#index")).to be_an_instance_of Array
      expect(Bijou::Router.new.root("pages#index")).to eql(
        [["/", {:controller=>"pages", :action=>"index"}]]
      )
    end
  end

  describe "#handle_request" do
    subject(:bijou_router) { Bijou::Router.new }

    it "Takes exactly one argument" do
      expect{ bijou_router.handle_request }.to raise_error ArgumentError
      expect{ bijou_router.handle_request("hello", "world") }.to raise_error ArgumentError
    end

    it "Returns a new route instance when a valid argument is passed in" do
      bijou_router.draw do
        get "/agenda/new", to: "pages#index"
      end

      allow(ENV).to receive(:path_info).and_return("/agenda/new")
      allow(ENV).to receive(:request_method).and_return("GET")

      expect(bijou_router.handle_request(ENV)).to be_an_instance_of Bijou::Route
    end

    it "Returns a new route instance when the route matches the defined route pattern" do
      bijou_router.draw do
        get "/agenda/:id", to: "pages#create"
      end

      allow(ENV).to receive(:path_info).and_return("/agenda/1")
      allow(ENV).to receive(:request_method).and_return("GET")
      allow(ENV).to receive(:params).and_return({})

      expect(bijou_router.handle_request(ENV)).to be_an_instance_of Bijou::Route
    end
  end

  describe "#parse_action" do
    subject(:bijou_router) { Bijou::Router.new }

    it "Should be a private method" do
      expect{ bijou_router.parse_action("pages#index") }.to raise_error NoMethodError
    end

    it "Takes exactly one argument" do
      expect{ bijou_router.send(:parse_action) }.to raise_error ArgumentError
      expect{ bijou_router.send(:parse_action, "hello", "world") }.to raise_error ArgumentError
    end

    it "Returns a hash using the argument
        to generate controller and action keys" do
        expect(bijou_router.send(:parse_action, "pages#index")).to be_an_instance_of Hash
        expect(bijou_router.send(:parse_action, "pages#index")).to eql(
          {:controller => "pages", :action => "index"}
        )
    end
  end

  describe "#generate_regex" do
    subject(:bijou_router) { Bijou::Router.new }

    it "Should be a private method" do
      expect{ bijou_router.generate_regex("/agenda/1") }.to raise_error NoMethodError
    end

    it "Takes exactly one argument" do
      expect{ bijou_router.send(:generate_regex) }.to raise_error ArgumentError
      expect{ bijou_router.send(:generate_regex, "hello", "world") }.to raise_error ArgumentError
    end

    it "Returns a new Regexp instance using the argument" do
        expect(bijou_router.send(:generate_regex, "/agenda/1")).to be_an_instance_of Regexp
        expect(bijou_router.send(:generate_regex, "/agenda/1")).to eql(/\/agenda\/:[a-z]+/)
    end
  end
end
