defmodule Circle do
  @moduledoc "Implements basic circle functions"

  @pi 3.14159

  @doc "Computes the area of a circle"
  def area(r), do: r*r*@pi

  @doc "Computes the circumference of a circle"
  def circumference(r), do: 2*r*@pi
end

# Code.fetch_docs(Circle) will return all the above documentation (and related info)
# h Circle.area (in iex console) will return only "Computes the area of a circle"
