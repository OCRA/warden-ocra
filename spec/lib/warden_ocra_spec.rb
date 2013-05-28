require 'spec_helper'

describe Warden::Ocra do
  before(:each) do
    post '/generate_challenge', :email => 'bla@blub.com'
  end

  context "first step" do
    it "should generate the challenge" do
      warden.user.challenge.should_not be_nil
    end

    it "should not authenticate user" do
      warden.should_not be_authenticated
    end
  end

  context "second step" do
    before(:each) do
      post '/login', :email => 'bla@blub.com', :response => '239172'
    end

    it "should authenticate the user" do
      warden.should be_authenticated
    end
  end
end
