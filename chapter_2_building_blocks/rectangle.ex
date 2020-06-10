defmodule Geometry do
  def rectangle(a), do: rectangle(a, 0)
  def rectangle(a, b), do: a * b
end

area = Geometry.rectangle(6)

IO.puts(area) #=> 0
