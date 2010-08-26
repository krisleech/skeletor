require 'test_helper'

class DocumentsTest < ActionController::IntegrationTest
  fixtures :all

  

  test "logging in with valid user credentials" do
    visit login_url      
    fill_in "Email", :with => "kris.leech@interkonect.com"
    fill_in "Password", :with => 'chester'      
    click_button "Login"
    assert_contain "Login successful!"
  end

  test "logging in with bad valid user credentials" do
    visit login_url
    fill_in "Email", :with => "kris.leech@interkonect.com"
    fill_in "Password", :with => 'secret'
    click_button "Login"
    assert_contain "prohibited"
  end

  context "logged in user" do
    setup do
      visit login_url
      fill_in "Email", :with => "kris.leech@interkonect.com"
      fill_in "Password", :with => 'chester'
      click_button "Login"
      assert_contain "successful"
    end

    should "be able to access admin" do
      visit '/admin'
      assert_contain 'Control Panel'
    end
  end

  context 'not logged in user' do
    should "be able to browse public content" do
      visit '/'
      visit '/blog'
      visit '/blog/my_first_post'
    end

    should "not be able to get to admin" do
      visit "/admin"
      assert_not_contain 'Control Panel'
    end
  end


end
