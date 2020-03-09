class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy

  enum role: %i(user editor admin)

  after_initialize :set_default_role, if: :new_record?

private
  def set_default_role
    self.role ||= :user
  end
end
