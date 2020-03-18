puts "Ведите дату (ДД/ММ/ГГГГ): "
date = gets.chomp.split('/').map {|i| i.to_i}
normal_year = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
puts date
ordinal = date[0]
i = 1
while i < date[1]
  ordinal += normal_year[i-1]
  i += 1
end
if (date[2] % 4 == 0 && date[2] % 100 != 0 || date[2] % 400 == 0) && date[1] > 2
  ordinal += 1
end
puts "Это #{ordinal}-й день года"
