defmodule True do
  def same(a, b), do: a == b
end

# true
result = True.same(9, 9)
IO.puts(result)

# false
result = True.same(9, "nine")
IO.puts(result)
