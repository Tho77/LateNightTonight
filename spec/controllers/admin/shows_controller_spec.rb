require 'spec_helper'

describe Admin::ShowsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'loadRss'" do
    it "returns http success" do
      get 'loadRss'
      response.should be_success
    end
  end

end
