alphabet = ('a'..'z').to_a
vowel_list = ['a', 'e', 'i', 'o', 'u', 'y']
vowels = {}
for i in 1..26
  vowels[alphabet[i-1]] = i if vowel_list.include?(alphabet[i-1])
end

