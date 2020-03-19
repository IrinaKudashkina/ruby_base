fibonacci = [1, 1]
while fibonacci[-1] + fibonacci[-2]  < 100
  fibonacci << fibonacci[-1] + fibonacci[-2]
end
puts fibonacci

