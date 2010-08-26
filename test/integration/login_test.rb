require 'test_helper'

class LoginTest < ActionController::IntegrationTest
  fixtures :all

  # webrat plus shoulda
  context 'logged in user' do
    setup do
      visit '/login'
      fill_in "Email", :with => "kris.leech@interkonect.com"
      fill_in "Password", :with => 'chester'           
      click_button "Login"
      assert_equal '/', path
#      assert_contains /successful/
    end

    should "be able to access admin" do
      visit '/admin'
    end

  end

  # standard rails
  def test_login_and_browse_site
    get "/login"
    assert_response :success

    post_via_redirect "/login", :email => users(:users_001).email, :password  => users(:users_001).password

    get "/blog"
    assert_response :success
    assert assigns(:posts)

    get "/blog/my_first_blog_post"
    assert_response :success
    assert assigns(:comments)

    get "/blog/archive/March/2010"
    assert_response :success
    assert assigns(:documents)
  end

  def rss_feed
    get "/blog.rss"
    assert_response :success
    assert assigns(:documents)
  end
end
