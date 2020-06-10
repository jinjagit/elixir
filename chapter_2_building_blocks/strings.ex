# double quotes spoecify a binary string - underneath this is simply
# a sequence of bytes (probably 8-bit)
string = "Hello"
IO.puts(string) #=> Hello

# Thus, <> can be used to concatenate binary strings
string = "I am " <> "binary!"
IO.puts(string) #=> I am binary!

a = 3 + 2
string = "embedded variable value: #{a}"
IO.puts(string) #=> embedded variable value: 5

string = ~s(I am also a string)
IO.puts(string) #=> I am also a string

# character lists can also represent strings. If a list consists
# of printable integers, it's printed as a string
string = [65, 66, 67]
IO.puts(string) #=> ABC

# single quotes signify character lists
string = 'ABC'
IO.puts(string) #=> ABC
