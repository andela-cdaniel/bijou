require "spec_helper"

describe "Dependencies" do
  it "Extends the base string class with a to_snake_case method" do
    expect("PagesController".respond_to? :to_snake_case).to be true
    expect("PagesController".to_snake_case).to eql("pages_controller")
  end

   it "Extends the base string class with a to_camel_case method" do
    expect("PagesController".respond_to? :to_camel_case).to be true
    expect("pages_controller".to_camel_case).to eql("PagesController")
  end

  it "Extends the base object class' const_missing method" do
    result = Object.const_missing("DependencyHelper")
    expect(result).to eql(DependencyHelper)
  end
end
