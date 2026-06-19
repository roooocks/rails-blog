class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # has_many :posts, dependent: :destroy # 이건 콜백 생성도 같이 한다.
  has_many :posts
  has_many :comments
end
