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
    
    it { should have_selector('title', text: user.name + " - profile") }
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
    
    describe "with valid info" do
      before do
        fill_in "Name",         with: "Username McDerpington"
        fill_in "Email",        with: "yoann.celton@gmail.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      
      it "should create account" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving user" do
        before { click_button submit }
        it {should have_link("Sign out", href: signout_path) }
      end
    end
  end
  
  describe "edit page" do
    let(:user) { FactoryGirl.create(:user) }
    before { 
      sign_in user
      visit edit_user_path(user) 
    }
    
    describe "page" do
      it { should have_selector('title',  text: "Edit user") }
      it { should have_selector('h1',     text: "Update your profile") }
      it { should have_link('Change',     href: "http://gravatar.com/emails") }
    end
    
    describe "with invalid info" do
      before { click_button "Save changes" }
      it { should have_content("error") }
    end
    
    describe "with valid info" do
      let(:new_name) { "New name" }
      let(:new_mail) { "new@mail.com" }
      before do
        fill_in "Name",         with: new_name
        fill_in "Email",        with: new_mail
        fill_in "Password",     with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end
      
      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_mail }
    end
   
  end
  
describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
    
    describe "Delete links" do
      it { should_not have_link('delete') }
    
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
end
