require 'spec_helper'

describe "UserPages" do
  subject {page}
  
  describe "signup page" do
    it "works!" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get signup_path
      response.status.should be(200)
    end
    before { visit signup_path }
    
    it { should have_content('Sign up') }
    it { should have_selector('title', text: 'BeardedSquid | Sign Up') }
  end
end
