puts "Ведите дату (ДД/ММ/ГГГГ): "
date = gets.chomp.split('/').map {|i| i.to_i}
normal_year = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
ordinal = date[0] + normal_year.take(date[1] - 1).sum
if (date[2] % 4 == 0 && date[2] % 100 != 0 || date[2] % 400 == 0) && date[1] > 2
  ordinal += 1
end
puts "Это #{ordinal}-й день года"
