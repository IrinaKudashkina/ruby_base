alphabet = ('a'..'z').to_a
vowel_list = ['a', 'e', 'i', 'o', 'u', 'y']
vowels = {}
alphabet.each.with_index(1) do |letter, index| #нумерация индексов начинается с 1
  vowels[letter] = index if vowel_list.include?(letter)
end


