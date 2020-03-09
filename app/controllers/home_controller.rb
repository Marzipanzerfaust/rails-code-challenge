class HomeController < ApplicationController
  def index
    categories = Article.distinct.pluck(:category)
    articles = categories.map { |c| Article.where(category: c).first(3) }

    @top_three = categories.zip(articles)
  end
end
