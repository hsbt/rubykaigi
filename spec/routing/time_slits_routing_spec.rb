require 'spec_helper'

describe TimeSlitsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/time_slits" }.should route_to(:controller => "time_slits", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/time_slits/new" }.should route_to(:controller => "time_slits", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/time_slits/1" }.should route_to(:controller => "time_slits", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/time_slits/1/edit" }.should route_to(:controller => "time_slits", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/time_slits" }.should route_to(:controller => "time_slits", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/time_slits/1" }.should route_to(:controller => "time_slits", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/time_slits/1" }.should route_to(:controller => "time_slits", :action => "destroy", :id => "1") 
    end
  end
end
