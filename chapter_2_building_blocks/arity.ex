# arity of functions means same name, different number of args = different functions

defmodule Geometry do
  def rectangle(a), do: rectangle(a, 0)
  def rectangle(a, b), do: a * b
end

area = Geometry.rectangle(6)

IO.puts(area) #=> 0

area = Geometry.rectangle(6, 7)

IO.puts(area) #=> 42

# specifying default arg value = generates 2nd function (with same name)
# and can generate more if more default args given

defmodule Geometry2 do
  def rectangle(a, b \\ 0), do: a * b
end

area = Geometry2.rectangle(6)

IO.puts(area) #=> 0

area = Geometry2.rectangle(6, 7)

IO.puts(area) #=> 42
