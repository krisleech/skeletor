require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should_not_allow_mass_assignment_of :password  

  context "A User instance" do
    setup do
      @user = User.find(:first)
    end

    should "return its full name" do
      assert_equal 'Kris Leech', @user.name
    end

  end 
end