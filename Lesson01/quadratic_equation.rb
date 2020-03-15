print "Коэффициент a = "
a = gets.chomp.to_f
print "Коэффициент b = "
b = gets.chomp.to_f
print "Коэффициент c = "
c = gets.chomp.to_f
d = b ** 2 - 4 * a * c
puts "Квадратное уравнение #{a}*x^2 + #{b}*x + #{c} = 0"
puts "Дискриминант равен #{d}"
if d > 0
  puts "Первый корень уравнения равен #{(- b + Math.sqrt(d)) / (2 * a)}"
  puts "Второй корень уравнения равен #{(- b - Math.sqrt(d)) / (2 * a)}"
elsif d == 0
  puts "Единственный корень уравнения равен #{- b  / (2 * a)}"
else
  puts "Корней нет"
end
