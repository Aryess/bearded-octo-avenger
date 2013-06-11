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
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

        before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
      
      describe "Should not access" do
        it "new user page" do
          get new_user_path
          response.should redirect_to(root_path)
        end
        
        it "create action" do
          user2 = User.new(name: "ezrzer", email: "retetert@fegerg.fr", password: "pwd", password_confirmation: "pwd")
          post '/users/', user: {name: "ezrzer", email: "retetert@fegerg.fr", password: "pwd", password_confirmation: "pwd"}
          response.should redirect_to(root_path)
        end
      end
    end
    
    describe "For non signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "in user controller" do
        describe "visit edit page" do
          before{ visit edit_user_path(user) }
          it { should have_selector('title', text: "Sign in")}
        end
        
        describe "Try to update user" do
          before {put user_path(user) }
          specify {response.should redirect_to(signin_path)}
        end
        
        describe "Visit index" do
          before {visit users_path}
          it {should have_selector('title', text: "Sign in")}
        end
      end
    end
    
    describe "As wrong user" do
      describe "in user controller" do
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
    
    describe "As admin" do
      let(:admin) {FactoryGirl.create(:admin)}
      before{sign_in admin}
      
      describe "No suicide" do
        
        it "should not succeed" do
          delete user_path(admin.id)
          response.should redirect_to(users_path)
        end
      end
    end
  
  end
  
end
