require 'date'
month_names = Date::MONTHNAMES.compact
days_number = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
months = month_names.zip(days_number).to_h
months.each do |month, days|
  puts month if days == 30
end

