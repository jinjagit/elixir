defmodule True do
  def same(a, b), do: a == b
end

result = True.same(9, 9)
IO.puts(result) #=> true

result = True.same(9, "nine")
IO.puts(result) #=> false
