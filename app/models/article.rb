class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true
  enum status: { draft: "draft", published: "published" }

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
end
