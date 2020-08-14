# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



require "open-uri"
require "json"

url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
read = open(url).read
json_parsed = JSON.parse(read)
json_parsed["drinks"].each do |ingredient|
  Ingredient.create(name: ingredient.values.first)
end

url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a"
read = open(url).read
json_parsed = JSON.parse(read)
json_parsed["drinks"].each do |cocktail|
  cocktail_name = cocktail["strDrink"]
  photo_url = cocktail["strDrinkThumb"]
  file = URI.open(photo_url)
  cocktail_created = Cocktail.create(name: cocktail_name)
  cocktail_created.photo.attach(io: file, filename: 'nes.png', content_type: 'image/png')
  ingredients_hash = cocktail.select { |k, _| k.include? "strIngredient" }
  ingredients_array = ingredients_hash.values.reject { |e| e.to_s.empty? }
  measures_hash = cocktail.select { |k, _| k.include? "strMeasure" }
  measures_array = measures_hash.values.reject { |e| e.to_s.empty? }
  i = 0
  ingredients_array.each do |ingredient|
    ingredient = Ingredient.where(name: ingredient).take
    dose_desc = measures_array[i]
    i += 1
    if ingredient
      Dose.create(description: dose_desc, cocktail_id: cocktail_created.id, ingredient_id: ingredient.id)
    end
  end
end
