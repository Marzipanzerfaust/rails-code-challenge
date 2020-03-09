require "application_system_test_case"

class GuestsTest < ApplicationSystemTestCase
  def setup
    @user = User.create(email: "user@test.com", password: "testing")

    categories = %w(foo bar baz)

    categories.each do |word|
      5.times do |i|
        Article.create(title: "#{word}_#{i}", content: "blah blah blah", category: word, user_id: @user.id)
      end
    end

    @top_three = categories.map { |c| Article.where(category: c).first(3) }
  end

  test "I can see the homepage with first three articles from each category" do
    visit root_path
    assert_selector "h1", text: "Home"

    @top_three.each do |articles|
      articles.each do |a|
        assert_selector "a", text: a.title
      end
    end
  end

  test "I can see the article index page" do
    visit root_path
    assert_link "See all articles"

    click_on "See all articles"
    assert_selector "h1", text: "Listing articles"
  end

  test "I am sent to a signup page when I try to view an article show page" do
    visit root_path
    click_on @top_three.first.first.title
    assert_text "You need to sign in or sign up before continuing."
  end

  test "I can sign up" do
    visit root_path
    assert_link "Sign up"

    click_on "Sign up"
    assert_current_path new_user_registration_path

    fill_in "Email", with: "baz@qux.com"
    fill_in "Password", with: "bazqux"
    fill_in "Password confirmation", with: "bazqux"
    click_on "Sign up"
    assert_current_path root_path
    assert_text "Welcome! You have signed up successfully."
  end

  test "I can log in" do
    visit root_path
    assert_link "Log in"

    click_on "Log in"
    assert_current_path new_user_session_path

    fill_in "Email", with: "user@test.com"
    fill_in "Password", with: "testing"
    click_on "Log in"
    assert_text "Signed in successfully."
  end
end
