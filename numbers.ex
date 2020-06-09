defmodule Numbers do
  def divide(a, b), do: a / b
  def divide2(a, b), do: div(a, b)
end

# integer result of division will become a float
result = Numbers.divide(6, 2)
IO.puts(result)

# using auto-imported Kernel "div" funcion will return an integre result as an integer
result = Numbers.divide2(6, 2)
IO.puts(result)
