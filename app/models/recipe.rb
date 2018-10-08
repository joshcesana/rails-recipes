class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_ingredients, inverse_of: :recipe
  has_many :ingredients, through: :recipe_ingredients
  has_many :directions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image

  accepts_nested_attributes_for :directions, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :recipe_ingredients, :allow_destroy => true

  validates :title, :description, presence: true
end
