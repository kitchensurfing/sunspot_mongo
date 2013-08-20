require 'spec_helper'

describe "Sunspot::Mongo" do

  describe MongoidTestDocument do
    subject { MongoidTestDocument }

    it "should call Sunspot.setup when searchable is called" do
      Sunspot.should_receive(:setup).once.with subject
      subject.searchable
      subject.searchable?.should be_true
    end

    it "should search" do
      options = {}
      Sunspot.should_receive(:new_search).once.and_return(double("search", :execute => nil))
      subject.solr_search(options)
    end

    it "should index and retrieve" do
      test_doc = subject.create :title => 'So much foo, so little bar.'
      test_doc.index!

      search = subject.solr_search do
        fulltext 'foo'
      end

      search.hits.length.should eql 1
      search.results.first.should eql test_doc
    end
  end

  describe "test documents with options" do
    it "should set sunspot_options" do
      MongoidTestDocument.sunspot_options.should == {:include => []}
    end

    context "with the Identity Map enabled" do
      before do
        Mongoid.identity_map_enabled = true
      end

      after do
        Mongoid.identity_map_enabled = false
      end

      it "supports includes" do
        test_doc = MongoidTestDocument.create! :title => 'So much foo, so little bar.'
        test_doc_two = MongoidTestDocumentTwo.create! :title => 'So much foo, so little bar.', mongoid_test_document: test_doc
        Sunspot.commit

        finder = MongoidTestDocument.includes(:mongoid_test_document_two)
        MongoidTestDocument.should_receive(:includes).with(:mongoid_test_document_two).and_return(finder)
        search_results = MongoidTestDocument.solr_search(include: :mongoid_test_document_two) do |query|
          query.fulltext 'foo'
        end.results

        search_results.first.mongoid_test_document_two.should == test_doc_two
      end
    end
  end
end
