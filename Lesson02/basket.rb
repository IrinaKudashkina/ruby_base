basket = {}
purchase = {}
cost = 0
amount = 0
loop do
  puts "Название товара: "
  name = gets.chomp
  break if name == 'стоп'
  puts "Цена за единицу: "
  price = gets.chomp.to_f
  puts "Количество: "
  quantity = gets.chomp.to_f
  purchase[price] = quantity
  basket[name] = purchase
  purchase = {}
end
puts basket
basket.each do |name, value|
  value.each {|price, quantity| cost = price * quantity}
  puts "#{name} на #{cost} рублей"
  amount += cost
end
puts "Общая сумма покупок #{amount} рублей"

