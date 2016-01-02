require "spec_helper"

describe Bijou::BijouRecord::HashToObj do
  subject(:hash_to_obj) { Bijou::BijouRecord::HashToObj }

  describe "#initialize" do
    it "Takes exactly one argument" do
      expect{ hash_to_obj.new }.to raise_error ArgumentError
      expect{ hash_to_obj.new({}, []) }.to raise_error ArgumentError
    end

    it "Sets the instance variables of the class based on the passed in hash" do
      result = hash_to_obj.new(name: "Test", done: "false")
      expect(result).to be_an_instance_of Bijou::BijouRecord::HashToObj
      expect(result.name).to eql("test")
      expect(result.done).to be false
    end
  end

  describe "#boolean" do
    it "Takes exactly one argument" do
      result = hash_to_obj.new(name: "Test", done: "false")
      expect{ result.boolean }.to raise_error ArgumentError
      expect{ result.boolean("hello", "world") }.to raise_error ArgumentError
    end

    it "Converts the string 'true' to the boolean true" do
      result = hash_to_obj.new(name: "Test", done: "false")
      expect(result.boolean("true")).to be true
    end

    it "Converts the string 'false' to the boolean false" do
      result = hash_to_obj.new(name: "Test", done: "false")
      expect(result.boolean("false")).to be false
    end

    it "Doesn't convert a string if it doesn't match 'true' or 'false'" do
      result = hash_to_obj.new(name: "Test", done: "false")
      expect(result.boolean("falsee")).to eql("falsee")
      expect(result.boolean("hello")).to eql("hello")
      expect(result.boolean("sony")).to eql("sony")
    end

    it "Doesn't convert numbers" do
      result = hash_to_obj.new(name: "Test", done: "false")
      expect(result.boolean(0)).to eql(0)
      expect(result.boolean(25)).to eql(25)
      expect(result.boolean(-89)).to eql(-89)
    end
  end
end
