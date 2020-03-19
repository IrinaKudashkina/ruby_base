basket = {}
amount = 0
loop do
  puts "Название товара: "
  name = gets.chomp
  break if name == 'стоп'
  puts "Цена за единицу: "
  price = gets.chomp.to_f
  puts "Количество: "
  quantity = gets.chomp.to_f
  basket[name] = {price: price, quantity: quantity}
end
puts basket
basket.each do |name, value|
  cost = value[:price] * value[:quantity]
  puts "#{name} на #{cost} рублей"
  amount += cost
end
puts "Общая сумма покупок #{amount} рублей"

