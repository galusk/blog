class Comment < ApplicationRecord
  validates :body, presence: true, length: { minimum: 6, maximum: 500 }
  #{ within 6..500 } { in 6..500 }
  validates :commenter, presence: true

  belongs_to :article
end
