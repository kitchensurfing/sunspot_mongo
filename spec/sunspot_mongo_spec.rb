require 'spec_helper'

describe "Sunspot::Mongo" do

  describe MongoidTestDocument do
    it_behaves_like "a mongo document"
  end

  describe "test documents with options" do
    it "should set sunspot_options" do
      MongoidTestDocument.sunspot_options.should == {:include => []}
    end
  end

end
