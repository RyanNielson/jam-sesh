require 'spec_helper'

describe PusherController do

  describe "GET 'auth'" do
    it "returns http success" do
      get 'auth'
      response.should be_success
    end
  end

end
