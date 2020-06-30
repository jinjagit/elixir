# Common top-level module prefix does not require previous declaration

defmodule Test.One do
  def response do
    IO.puts "One"
  end
end

defmodule Test.Two do
  def response do
    IO.puts "Two"
  end
end

Test.One.response #=> One
Test.Two.response #=> Two
