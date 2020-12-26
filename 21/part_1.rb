require_relative '../read_file.rb'

input_list = read_file('test_input.txt') do |line|
    ingredients, allergens = line.chomp.split('(')
    ingredients = ingredients.strip.split(' ')
    allergens = allergens.gsub('contains ', '').gsub(')', '').split(', ')
    {
        ingredients: ingredients,
        allergens: allergens
    }
end

allergen_list = input_list.map { |i| i[:allergens] }.flatten.uniq
puts allergen_list

allergen_to_ingredient_map = allergen_list.inject({}) do |hash, allergen|
    ingredients = []
    input_list.each do |i|
        if i[:allergens].include? allergen
            ingredients << i[:ingredients]
        end
    end
    hash[allergen] = ingredients.flatten.uniq
    hash
end
puts allergen_to_ingredient_map