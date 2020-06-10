defmodule Elements do
 def get_elem(list, index), do: elem(list, index)
end

list = {22, "hello", 47.6, true}

result = Elements.get_elem(list, 0)
IO.puts(result) #=> 22

result = Elements.get_elem(list, 1)
IO.puts(result) #=> "hello"

result = Elements.get_elem(list, 2)
IO.puts(result) #=> 47.6

result = Elements.get_elem(list, 3)
IO.puts(result) #=> true
