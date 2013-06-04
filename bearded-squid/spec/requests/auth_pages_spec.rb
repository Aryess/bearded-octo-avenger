require 'spec_helper'

describe "AuthPages" do
  
  subject { page }
  
  describe "Signin page" do
    before { visit signin_path }   
    let(:submit) { "Sign in" }
    
    it { should have_selector('h1',   text: "Sign in") }
    it { should have_selector('title', text: "Sign in") }
    
    describe "with no info" do
      before { click_button submit }
      
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
    end
    
    describe "with wrong pwd" do
    let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password + "nope"
        click_button submit
      end
      
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      describe "after visiting another page" do
        before { click_link "About" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
      
    describe "with valid info" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user}
      
      it { should have_selector('title', text: user.name + " - profile") }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Sign out', href: signout_path) }
      
      describe "and then signout" do
        before { click_link "Sign out" }
        it { should have_selector('div.alert.alert-success', text: "See you soon") }
        it { should have_selector('title', text: "Home") }
        it { should have_link("Sign in", href: signin_path) }
        it { should_not have_link('Profile', href: user_path(user)) }
        it { should_not have_link('Settings', href: edit_user_path(user)) }
        it { should_not have_link('Sign out', href: signout_path) }
      end
    end
  end
  
  describe "Authorization" do
    describe "For non signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "visit edit page" do
        before{ visit edit_user_path(user) }
        it { should have_selector('title', text: "Sign in")}
      end
      
      describe "Try to update user" do
        before {put user_path(user) }
        specify {response.should redirect_to(signin_path)}
      end
    end
    
    describe "As wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@gmail.com") }
      before { sign_in user }
      
      describe "Visiting users#edit" do
        before {visit edit_user_path(wrong_user)}
        it {should_not have_selector('title', text: "Edit user")}
      end
      
      describe "Trying to PUT to users" do
        before {put user_path(wrong_user)}
        specify {response.should redirect_to(root_path)}
      end
    end
  end
  
end
