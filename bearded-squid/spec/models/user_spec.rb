require 'spec_helper'

describe User do

  before { @user = User.new(name: "Example User", email: "user@example.com", 
                   password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should be_valid }

  describe "When no name" do
    before { @user.name = "" }
    it { should_not be_valid }
  end

  describe "When name too long" do
    before { @user.name = "a"*51 }
    it {should_not be_valid }
  end
  describe "When no email" do
    before { @user.email = "" }
    it { should_not be_valid }
  end
  
  describe "When email too long" do
    before { @user.email = "a"*256 }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com user@mail.ongtf]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.co.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end      
    end
  end
  
  describe "email is unique" do
    before do 
      user2 = @user.dup
      user2.email = @user.email.upcase
      user2.save
    end
    
    it { should_not be_valid }
  end
  
  describe "when no password" do
    before { @user = User.new(name: "Example User", email: "user@example.com", 
                   password: "", password_confirmation: "")}
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "when password confirmation is nil" do
    before do
      @user = User.new(name: "Michael Hartl", email: "mhartl@example.com",
                       password: "foobar", password_confirmation: nil)
    end
    it { should_not be_valid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let (:found_user) { User.find_by_email(@user.email) }
    
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
    
    describe "with invalid password" do
      let (:invalid_user) { User.find_by_email("trololo") }
      it { should_not eq invalid_user }
      specify { expect(invalid_user).to be_false}
    end
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
