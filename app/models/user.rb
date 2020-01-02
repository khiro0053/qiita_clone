# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true, length: { in: 2..50 }
  # emailのフォーマットについてはdevice-token-auth側で/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/iと設定されている
  validates :email, presence: true, uniqueness: true
  # 半角英小文字大文字数字をそれぞれ1種類以上含む半角英数字記号
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[!-~]+\z/.freeze
  validates :password, presence: true, length: { in: 8..32 }, format: { with: VALID_PASSWORD_REGEX }, on: :create

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
end
