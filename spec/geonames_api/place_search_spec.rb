require 'spec_helper'

describe GeoNamesAPI::PlaceSearch do
  describe "::find" do
    it "should search for places dealing with ohio" do
      search = GeoNamesAPI::PlaceSearch.find("ohio", "10")
      search.should be_present
      search.total_results_count.should > 0
      search.results.size.should == 10
    end
  end

  describe "::find_by_place_name" do
    it "should find the place by name" do
      search = GeoNamesAPI::PlaceSearch.find_by_place_name("ohio", "10")
      search.total_results_count.should > 0
      search.results.each{|place| place.name.should =~ /ohio/i }
    end
  end

  describe "::find_by_exact_place_name" do
    it "should find the place by the exact name" do
      search = GeoNamesAPI::PlaceSearch.find_by_exact_place_name("columbus", "10")
      search.total_results_count.should > 0
      search.results.each{|place| place.name.downcase.should == 'columbus' }
    end
  end

  describe "#next_page" do
    it "should grab the next page of results from the same search" do
      search3 = GeoNamesAPI::PlaceSearch.find("columbus", "3").results
      search2 = GeoNamesAPI::PlaceSearch.find("columbus", "2")
      search2.results.first.geoname_id.should == search3[0].geoname_id
      search2.results.last.geoname_id.should == search3[1].geoname_id
      search2.next_page.results.first.geoname_id.should == search3[2].geoname_id
    end
  end

  describe "#to_page" do
    it "should grab the specified page of results from the same search" do
      search10 = GeoNamesAPI::PlaceSearch.find("columbus", "10").results
      search2 = GeoNamesAPI::PlaceSearch.find("columbus", "2")
      search2.to_page(4).results.first.geoname_id.should == search10[6].geoname_id
    end
  end
end