require "application_system_test_case"

class EditorsTest < ApplicationSystemTestCase
  def setup
    @editor = User.create(email: "editor@test.com", password: "testing")
    @editor.editor!

    @other_editor = User.create(email: "other@test.com", password: "testing")
    @other_editor.editor!

    sign_in @editor

    @my_article = Article.create(
      title: "title",
      content: "content",
      category: "category",
      user: @editor
    )

    @other_article = Article.create(
      title: "foo",
      content: "bar",
      category: "bleh",
      user: @other_editor
    )
  end

  test "I can create articles" do
    visit articles_path
    click_on "New Article"
    fill_in "Title", with: "Title"
    fill_in "Content", with: "Content"
    fill_in "Category", with: "Category"
    click_on "Create Article"
    assert_text "Article was successfully created."
    assert Article.find_by(title: "Title")
  end

  test "I can delete ONLY articles that I created" do
    visit articles_path
    click_link_for @editor.email, "Destroy"
    accept_alert
    assert_text "Article was successfully destroyed."

    click_link_for @other_editor.email, "Destroy"
    accept_alert
    assert_not_authorized
  end

  test "I can edit ONLY articles that I created" do
    visit articles_path
    click_link_for @editor.email, "Edit"
    fill_in "Title", with: "different text"
    click_on "Update Article"
    assert_text "Article was successfully updated."

    visit articles_path
    click_link_for @other_editor.email, "Edit"
    assert_not_authorized
  end
end
