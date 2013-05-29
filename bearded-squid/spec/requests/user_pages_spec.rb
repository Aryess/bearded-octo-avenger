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
  
  describe "profile page" do
    #generate user
    let(:user) { FactoryGirl.create(:user)}
    before{ visit user_path(user) }
    
    it { should have_selector('title', text:"User profile") }
    it { should have_selector('h1', text: user.name) }
  end
  
  describe "Signup page" do
    before { visit signup_path }
    let(:submit) { "Create my account"}
    
    describe "with invalid info" do
      it "should not create account" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    
    describe "with invalid info" do
      before do
        fill_in "Name",         with: "Username McDerpington"
        fill_in "Email",        with: "yoann.celton@gmail.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      
      it "should create account" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
