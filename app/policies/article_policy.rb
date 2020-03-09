class ArticlePolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    @user.editor?
  end

  def update?
    @user.editor? && @user == @record.user
  end

  def destroy?
    update?
  end
end
