require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase

  context "on GET to /blog" do
    setup do
      get :show, :id => Document.find_by_path('blog')      
    end

    should_respond_with :success    
    should_assign_to :document
    #      should_assign_to :blog
    #      should_assign_to :posts
    should_respond_with :success
    #     should_render_template 'blog.html.erb'
    #      assert_template 'blog.html.erb'
  end

 

  test "should show homepage" do
    get :show
    assert_response :success
#    assert_equal '/', @response.path
  end

  test "should show 404" do
    get :show, :id => 'does_not_exists'
    assert_response 404
  end
end