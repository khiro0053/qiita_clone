# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true, length: { in: 2..50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]+\z/.freeze
  validates :password, presence: true, length: { in: 8..32 }, format: { with: VALID_PASSWORD_REGEX }

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
end
