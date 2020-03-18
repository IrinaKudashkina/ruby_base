require 'date'
month_names = Date::MONTHNAMES.compact
days_number = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
months = {}
for i in 1..12
  months[month_names[i-1]] = days_number[i-1]
end
months.each do |month, days|
  puts month if days == 30
end
