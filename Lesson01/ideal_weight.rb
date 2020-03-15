puts "Как Вас зовут?"
name = gets.chomp
puts "#{name}, введите Ваш рост в сантиметрах"
height = gets.chomp
ideal_weight = (height.to_i - 110) * 1.15
if ideal_weight < 0
  puts "Ваш вес уже оптимальный"
else
  puts "#{name}, Ваш идеальный вес #{ideal_weight} кг"
end
