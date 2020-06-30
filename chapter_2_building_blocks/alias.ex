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

alias Test.One, as: Bibble


Test.One.response #=> One
Test.Two.response #=> Two

Bibble.response #=> One
Bobble.response #=> Two
