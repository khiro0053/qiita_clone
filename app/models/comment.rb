class Comment < ApplicationRecord
  validates :body, presence: ture

  belongs_to :user
  belongs_to :article
end
