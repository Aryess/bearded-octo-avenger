require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get "static_pages/home"
      response.status.should be(200)
    end

    it "haz content 'Bearded Squid'" do
      visit '/static_pages/home'
      page.should have_selector('h1', text: 'Bearded Squid')
    end
    
    it "haz tittle 'home' " do
      visit '/static_pages/home'
      page.should have_selector('title', text: " | Home")
    end
  end
  
  describe "Help page" do
    it "works!" do
      get "static_pages/help"
      response.status.should be(200)
    end
    
    it "haz content 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', text: 'Help')
    end
    
    it "haz tittle 'Help' " do
      visit '/static_pages/help'
      page.should have_selector('title', text: " | Help")
    end
  end
  
  describe "About page" do
    it "works!" do
      get "static_pages/about"
      response.status.should be(200)
    end
    
    it "haz content 'About'" do
      visit '/static_pages/about'
      page.should have_selector('h1', text: 'About')
    end
      
    it "haz tittle 'About' " do
      visit '/static_pages/about'
      page.should have_selector('title', text: " | About")
    end
  end
end
