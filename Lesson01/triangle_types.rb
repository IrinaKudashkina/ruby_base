sides = []
for i in 1..3
  puts "Чему равна #{i}-я сторона треугольника?"
  sides[i-1] = gets.chomp.to_f
end
sides.sort!.reverse!

if sides[0] == sides[1] || sides[1] == sides[2]
  puts "Равнобедренный треугольник"
  if sides[0] == sides[2]
    puts "Равносторонний треугольник"
  end
elsif sides[0] ** 2 == sides[1] ** 2 + sides[2] ** 2
  puts "Прямоугольный треугольник"
else
  puts "Разносторонний треугольник без прямых углов"
end
