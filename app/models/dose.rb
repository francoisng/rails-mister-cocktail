class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient
  validates :description, :cocktail, :ingredient, presence:true 
  validates_uniqueness_of :cocktail, scope: :ingredient
end
