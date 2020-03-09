require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  def setup
    @user = User.create(email: "foo@bar.com", password: "foobar")
    sign_in @user

    @article = Article.create(title: "title", content: "content", category: "category", user: @user)
  end

  test "I can see article show pages" do
    visit articles_path
    click_on "Show"
    assert_link "Edit"
    assert_link "Back"
  end

  test "I can log out" do
    visit root_path
    click_on "Log out"
    assert_link "Sign up"
    assert_link "Log in"
  end

  test "I can NOT create new articles" do
    visit articles_path
    click_on "New Article"
    assert_not_authorized
  end
end
