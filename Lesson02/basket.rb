basket = {}
purchase = {}
amount = 0
loop do
  puts "Название товара: "
  name = gets.chomp
  break if name == 'стоп'
  puts "Цена за единицу: "
  purchase[:price] = gets.chomp.to_f
  puts "Количество: "
  purchase[:quantity] = gets.chomp.to_f
  basket[name] = purchase
  purchase = {}
end
puts basket
basket.each do |name, value|
  cost = value[:price] * value[:quantity]
  puts "#{name} на #{cost} рублей"
  amount += cost
end
puts "Общая сумма покупок #{amount} рублей"

