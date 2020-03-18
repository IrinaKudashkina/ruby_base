fibonacci = [1, 1]
n = 2
while fibonacci[n-1] + fibonacci[n-2]  < 100
  fibonacci << fibonacci[n-1] + fibonacci[n-2]
  n += 1
end


