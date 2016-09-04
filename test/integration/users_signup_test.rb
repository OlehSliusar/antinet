require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
   test "invalid submission" do
     get signup_path
     assert_no_difference 'User.count' do
       assert_select 'form[action="/users"]'
       post signup_path, params: { user: { name:  "",
                                     email: "user@invalid",
                                     password:              "foo",
                                     password_confirmation: "bar" } }
     end
     assert_template 'users/new'
     assert_select 'div#error_explanation'
     assert_select 'div.alert', "The form contains 4 errors."
     assert_select 'div.field_with_errors', count: 8
   end

   test "valid signup information" do
     get signup_path
     assert_difference 'User.count', 1 do
       post signup_path, params: { user: { name: "Foo Bar",
                                    email: "user@valid.com",
                                    password:              "foobar",
                                    password_confirmation: "foobar" } }
     end
     follow_redirect!
     assert_template 'users/show'
     assert_not flash.empty?
     assert is_logged_in?
   end
end