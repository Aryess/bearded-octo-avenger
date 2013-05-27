require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "works!" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get home_path
      response.status.should be(200)
    end

    it "haz content 'Bearded Squid'" do
      visit home_path
      page.should have_selector('h1', text: 'Bearded Squid')
    end
    
    it "haz tittle 'home' " do
      visit home_path
      page.should have_selector('title', text: " | Home")
    end
  end
  
  describe "Help page" do
    it "works!" do
      get help_path
      response.status.should be(200)
    end
    
    it "haz content 'Help'" do
      visit help_path
      page.should have_selector('h1', text: 'Help')
    end
    
    it "haz tittle 'Help' " do
      visit help_path
      page.should have_selector('title', text: " | Help")
    end
  end
  
  describe "About page" do
    it "works!" do
      get about_path
      response.status.should be(200)
    end
    
    it "haz content 'About'" do
      visit about_path
      page.should have_selector('h1', text: 'About')
    end
      
    it "haz tittle 'About' " do
      visit about_path
      page.should have_selector('title', text: " | About")
    end
  end
  
  describe "Contact page" do
    it "works!" do
      get contact_path
      response.status.should be(200)
    end
    
    it "haz content 'Contact'" do
      visit contact_path
      page.should have_selector('h1', text: 'Contact')
    end
      
    it "haz tittle 'Contact' " do
      visit contact_path
      page.should have_selector('title', text: " | Contact")
    end
  end
end
