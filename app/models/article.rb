class Article < ApplicationRecord
  belongs_to :user
  has_many :article_likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :body, presence: true
  validates :title, presence: true, length: { maximum: 45 }
end
