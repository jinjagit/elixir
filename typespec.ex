# @spec to indicate specific types

defmodule Circle2 do
  @pi 3.14159

  @spec area(number) :: number
  def area(r), do: r*r*@pi

  @spec circumference(number) :: number
  def circumference(r), do: 2*r*@pi
end

# Code.Typespec.fetch_specs(Map) will show the specs in the iex console
# (in a rather raw format)
