require "application_system_test_case"

class AdminsTest < ApplicationSystemTestCase
  def setup
    @admin = User.create(email: "admin@test.com", password: "testing")
    @admin.admin!

    sign_in @admin

    @user = User.create(email: "foo@bar.com", password: "foobar")

    @article = Article.create(title: "title", content: "content", category: "category", user: @user)
  end

  test "I can create users and set roles" do
    visit root_path
    click_on "Manage users"
    assert_current_path users_path

    click_on "New User"
    assert_current_path new_user_path

    fill_in "Email", with: "new_user@test.com"
    fill_in "Password", with: "testing"
    select "editor", from: "Role"
    click_on "Create User"
    assert_text "User was successfully created."
    assert User.find_by(email: "new_user@test.com")
  end

  test "I can edit users and change roles" do
    visit users_path
    click_link_for @user.email, "Edit"
    assert_current_path edit_user_path(@user)

    fill_in "Email", with: "bar@foo.com"
    fill_in "Password", with: "foobar"
    select "editor", from: "Role"
    click_on "Update User"
    assert_text "User was successfully updated."
    assert User.find_by(email: "bar@foo.com")
  end

  test "Non-admins do not have access to the user management page" do
    sign_in @user
    visit users_path
    assert_not_authorized
    assert_current_path root_path

    sign_in @admin
  end

  test "I can't edit, destroy, or create articles" do
    visit articles_path
    click_on "Edit"
    assert_not_authorized

    click_on "Destroy"
    accept_alert
    assert_not_authorized

    click_on "New Article"
    assert_not_authorized
  end
end
